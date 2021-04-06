//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    
    var activeSubscription = true

    var testTypes = [TestType]()
    let courseId = BehaviorRelay<Int?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    let loadNextTestSignal = BehaviorRelay<Void>(value: ())
    let tryAgainSignal = PublishRelay<Void>()
    
    lazy var courseName = makeCourseName()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var bottomViewState = makeBottomState()
    lazy var errorMessage = makeErrorMessage()
    lazy var needPayment = makeNeedPayment()
    lazy var leftCounterValue = makeLeftCounterContent()
    lazy var rightCounterValue = makeRightCounterContent()
    lazy var testStatsElement = makeTestStatsElement()
    private(set) lazy var currentTestType = makeCurrentTestType().share(replay: 1, scope: .forever)
    private(set) var testType: TestType? = nil
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var scoreRelay = PublishRelay<Bool>()
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
    private lazy var currentTestElement = Observable.merge(testElement, tryAgainTest()).share(replay: 1, scope: .forever)
    private lazy var selectedAnswers = makeSelectedAnswers().share(replay: 1, scope: .forever)
    private lazy var currentAnswers = makeCurrentAnswers().share(replay: 1, scope: .forever)
    private lazy var questionProgress = makeQuestionProgress().share(replay: 1, scope: .forever)
    private lazy var timer = makeTimer().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension TestViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .rxGetSelectedCourse()
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        let questions = currentTestElement
            .compactMap { $0.element?.questions }
            .map(questionElementMapper)
        
        let currentQuestion = Observable<Action>
            .merge(questions.map { .elements($0) }, didTapNext.map { _ in .next })
            .scan((nil, []),accumulator: currentQuestionAccumulator)
            .compactMap { $0.0.map { TestAction.question($0) } }
        
        let test = Observable
            .merge(currentQuestion, selectedAnswers.map { .answer($0) })
            .scan(nil, accumulator: answerQuestionAccumulator)
            .compactMap { $0 }
        
        return test.asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func tryAgainTest() -> Observable<Event<Test>> {
        tryAgainSignal
            .withLatestFrom(testElement)
            .withLatestFrom(courseId) { ($0, $1) }
            .flatMapLatest { [weak self] value, courseId -> Observable<Event<Test>> in
                guard let self = self, let userTestId = value.element?.userTestId, let courseId = courseId else { return .empty() }
                
                return self.questionManager
                    .againTest(courseId: courseId, testId: userTestId, activeSubscription: self.activeSubscription)
                    .compactMap { $0 }
                    .asObservable()
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func loadTest() -> Observable<Event<Test>> {
        Observable.combineLatest(courseId, currentTestType)
            .flatMapLatest { [weak self] courseId, type -> Observable<Event<Test>> in
                guard let self = self,  let courseId = courseId else { return .empty() }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId), let .timedQuizz(testId):
                    test = self.questionManager.retrieve(courseId: courseId,
                                                         testId: testId,
                                                         activeSubscription: self.activeSubscription)
                case .tenSet:
                    test = self.questionManager.retrieveTenSet(courseId: courseId,
                                                               activeSubscription: self.activeSubscription)
                case .failedSet:
                    test = self.questionManager.retrieveFailedSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                case .qotd:
                    test = self.questionManager.retrieveQotd(courseId: courseId,
                                                             activeSubscription: self.activeSubscription)
                case .randomSet:
                    test = self.questionManager.retrieveRandomSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                }
                
                return test
                    .compactMap { $0 }
                    .asObservable()
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func makeCurrentTestType() -> Observable<TestType> {
        loadNextTestSignal.debug()
            .compactMap { [weak self] _ -> TestType? in
                self?.testType = self?.testTypes.removeFirst()
                return self?.testType
            }
    }
    
    func makeErrorMessage() -> Signal<String> {
        currentTestElement
            .compactMap { $0.error?.localizedDescription }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        currentTestElement
            .map { [weak self] event in
                guard let self = self, let element = event.element else { return false }
                return self.activeSubscription ? false : element.paid ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeTestStatsElement() -> Observable<TestStatsElement> {
        let didFinishTest = timer
            .compactMap { $0 == 0 ? () : nil }
            .withLatestFrom(currentTestElement)
            .flatMap { [weak self] value -> Observable<Int> in
                guard let self = self, let userTestId  = value.element?.userTestId else { return .empty() }
                return self.questionManager
                    .finishTest(userTestId: userTestId)
                    .andThen(.just(userTestId))
            }
        
        let submit = didTapSubmit
            .withLatestFrom(currentTestElement)
            .compactMap { $0.element?.userTestId }
        
        return Observable.merge(didFinishTest, submit)
            .withLatestFrom(currentTestType) { ($0, $1) }
            .compactMap { [weak self] userTestId, testType -> TestStatsElement? in
                guard let self = self else { return nil }
                return TestStatsElement(userTestId: userTestId, testType: testType, isEnableNext: !self.testTypes.isEmpty)
            }
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable
            .merge(
                answers.asObservable(),
                Observable.merge(didTapNext.asObservable(), tryAgainSignal.asObservable(), loadNextTestSignal.asObservable()).map { _ in nil }
            )
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(currentTestElement) {
                ($0, $1.element?.userTestId)
                
            }
            .flatMapLatest { [questionManager] element, userTestId -> Observable<Bool> in
                guard let userTestId = userTestId else {
                    return .just(false)
                    
                }
                
                return questionManager
                    .sendAnswer(
                        questionId: element.questionId,
                        userTestId: userTestId,
                        answerIds: element.answerIds
                    )
                    .catchAndReturn(nil)
                    .compactMap { $0 }
                    .asObservable()
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<TestBottomButtonState> {
        Driver.combineLatest(isEndOfTest, question, currentAnswers.asDriver(onErrorJustReturn: nil))
            .map { isEndOfTest, question, answers -> TestBottomButtonState in
                let isResult = question.elements.contains(where: {
                    guard case .result = $0 else { return false }
                    return true
                })
                
                if question.index == question.questionsCount, question.questionsCount != 1, isResult {
                    return isEndOfTest ? .submit : .hidden
                } else {
                    guard isResult && question.questionsCount == 1 else {
                        return isResult ? .hidden : answers?.answerIds.isEmpty == false ? .confirm : .hidden
                    }
                    
                    return .back
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeScore() -> Observable<String> {
        Observable
            .merge(tryAgainSignal.asObservable(), loadNextTestSignal.asObservable())
            .flatMapLatest { [scoreRelay] _ in
                scoreRelay
                    .scan(0) { $1 ? $0 + 1 : $0 }
                    .map { score -> String in
                        score < 10 ? "0\(score)" : "\(score)"
                    }
                    .startWith("00")
                    .distinctUntilChanged()
            }
    }
    
    func makeTimer() -> Observable<Int> {
        currentTestElement
            .compactMap { $0.element }
            .withLatestFrom(currentTestType) { ($0.timeLeft, $1) }
            .flatMapLatest { seconds, testType -> Observable<Int> in
                guard let seconds = seconds, case .timedQuizz = testType else { return .empty() }
                let startTime = CFAbsoluteTimeGetCurrent()
                
                return Observable<Int>
                    .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in Int(CFAbsoluteTimeGetCurrent() - startTime) }
                    .take(until: { $0 >= seconds }, behavior: .inclusive)
                    .map { max(0, seconds - $0) }
                    .distinctUntilChanged()
            }
    }
    
    func makeLeftCounterContent() -> Driver<String> {
        currentTestType
            .flatMapLatest { [weak self] type -> Observable<String> in
                guard let self = self else { return .just("00") }
                
                let result: Observable<String>
                if case .timedQuizz = type {
                    result = self.questionProgress
                } else {
                    result = self.makeScore()
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeRightCounterContent() -> Driver<(value:String, isError: Bool)> {
        currentTestType
            .flatMapLatest { [weak self] type -> Observable<(value: String, isError: Bool)> in
                guard let self = self else { return .just((value: "00", isError: false)) }
                
                let result: Observable<(value: String, isError: Bool)>
                if case .timedQuizz = type {
                    result = self.timer
                        .map { (value: $0.secondsToString(), isError: $0 < 10) }
                } else {
                    result = self.questionProgress.map { (value: $0, isError: false) }
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestionProgress() -> Observable<String> {
        question
            .map { "\($0.index)/\($0.questionsCount)" }
            .asObservable()
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previos
        case elements([QuestionElement])
    }
    
    enum TestAction {
        case question(QuestionElement)
        case answer(AnswerElement?)
    }
    
    var questionElementMapper: ([Question]) -> [QuestionElement] {
        return { questions in
            return questions.enumerated().map { index, question -> QuestionElement in
                let answers = question.answers.map { PossibleAnswerElement(id: $0.id, answer: $0.answer, image: $0.image, isCorrect: $0.isCorrect) }
                
                let content: [QuestionContentType] = [
                    question.image.map { .image($0) },
                    question.video.map { .video($0) }
                ].compactMap { $0 }
                
                let elements: [TestingCellType] = [
                    !content.isEmpty ? .content(content) : nil,
                    .question(question.question, html: question.questionHtml),
                    .answers(answers)
                ].compactMap { $0 }
                
                return QuestionElement(
                    id: question.id,
                    elements: elements,
                    isMultiple: question.multiple,
                    index: index + 1,
                    isAnswered: question.isAnswered,
                    questionsCount: questions.count,
                    explanation: question.explanation
                )
            }
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            let withoutAnswered = elements.filter { !$0.isAnswered }
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                let withoutAnswered = questions.filter { !$0.isAnswered }
                return (withoutAnswered.first, questions)
            case .next:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            case .previos:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
    
    var answerQuestionAccumulator: (QuestionElement?, TestAction) -> QuestionElement? {
        return { [weak self] old, action -> QuestionElement? in
            switch action {
            case .question(let question):
                return question
            case .answer(let answers):
                guard let answers = answers, let currentQuestion = old else { return old }
                let newElements = currentQuestion.elements.map { value -> TestingCellType in
                    guard case let .answers(possibleAnswers) = value else { return value }
                    
                    let result = possibleAnswers.map { answer -> AnswerResultElement in
                        let state: AnswerState = answers.answerIds.contains(answer.id)
                            ? answer.isCorrect ? .correct : .error
                            : answer.isCorrect ? currentQuestion.isMultiple ? .warning : .correct : .initial
                        
                        return AnswerResultElement(answer: answer.answer, image: answer.image, state: state)
                    }
                    
                    if currentQuestion.isMultiple {
                        let isCorrect = !result.contains(where: { $0.state == .warning || $0.state == .error })
                        self?.scoreRelay.accept(isCorrect)
                        self?.logAnswerAnalitycs(isCorrect: isCorrect)
                    } else {
                        let isCorrect = !result.contains(where: { $0.state == .error })
                        self?.scoreRelay.accept(isCorrect)
                        self?.logAnswerAnalitycs(isCorrect: isCorrect)
                    }
                    
                    return .result(result)
                }
                
                let explanation: [TestingCellType] = currentQuestion.explanation.map { [.explanation($0)] } ?? []
                
                return QuestionElement(
                    id: currentQuestion.id,
                    elements: newElements + explanation,
                    isMultiple: currentQuestion.isMultiple,
                    index: currentQuestion.index,
                    isAnswered: currentQuestion.isAnswered,
                    questionsCount: currentQuestion.questionsCount,
                    explanation: currentQuestion.explanation
                )
            }
        }
    }
}

private extension TestViewModel {
    
    func logAnswerAnalitycs(isCorrect: Bool) {
        guard let type = testType, let courseName = courseManager.getSelectedCourse()?.name else {
            return
        }
        let name = isCorrect ? "Question Answered Correctly" : "Question Answered Incorrectly"
        let mode = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: ["course" : courseName, "mode": mode])
    }
}

private extension Int {
    func secondsToString() -> String {
        let seconds = self
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        
        return String(format: "%02d:%02d", mins, secs)
    }
}
