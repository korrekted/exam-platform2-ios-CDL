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
    
    let testType = BehaviorRelay<TestType?>(value: nil)
    let courseId = BehaviorRelay<Int?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var courseName = makeCourseName()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    lazy var errorMessage = makeErrorMessage()
    lazy var needPayment = makeNeedPayment()
    lazy var leftCounterValue = makeLeftCounterContent()
    lazy var rightCounterValue = makeRightCounterContent()
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var scoreRelay = BehaviorRelay<Bool>(value: false)
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
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
        Observable<Action>
            .merge(
                didTapNext.debounce(.microseconds(500), scheduler: MainScheduler.instance).map { _ in .next },
                makeQestions().map { .elements($0) }
            )
            .scan((nil, []), accumulator: currentQuestionAccumulator)
            .compactMap { $0.0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQestions() -> Observable<[QuestionElement]> {
        let questions = testElement
            .compactMap { $0.element?.questions }
        
        let dataSource = Observable
            .combineLatest(questions, selectedAnswers)
            .scan([], accumulator: questionAccumulator)
        
        return dataSource
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func loadTest() -> Observable<Event<Test>> {
        Observable.zip(courseId, testType)
            .flatMapLatest { [weak self] courseId, type -> Observable<Event<Test>> in
                guard
                    let self = self,
                    let courseId = courseId,
                    let type = type
                else { return .empty() }
                
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
    
    func makeErrorMessage() -> Signal<String> {
        testElement
            .compactMap { $0.error?.localizedDescription }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        testElement
            .map { [weak self] event in
                guard let self = self, let element = event.element else { return false }
                return self.activeSubscription ? false : element.paid ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }

    func makeUserTestId() -> Observable<Int> {
        let didFinishTest = timer
            .compactMap { $0 == 0 ? () : nil }
            .withLatestFrom(testElement)
            .flatMap { [weak self] value -> Observable<Int> in
                guard let self = self, let userTestId  = value.element?.userTestId else { return .empty() }
                return self.questionManager
                    .finishTest(userTestId: userTestId)
                    .andThen(.just(userTestId))
            }
        
        let submit = didTapSubmit
            .withLatestFrom(testElement)
            .compactMap { $0.element?.userTestId }
        
        return Observable.merge(didFinishTest, submit)
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable.merge(answers.asObservable(), didTapNext.map { _ in nil })
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(testElement) {
                ($0, $1.element?.userTestId)
                
            }
            .flatMapLatest { [questionManager] element, userTestId -> Observable<Bool> in
                guard let userTestId = userTestId else { return .just(false) }
                
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
        scoreRelay
            .scan(0) { $1 ? $0 + 1 : $0 }
            .map { score -> String in
                score < 10 ? "0\(score)" : "\(score)"
            }
            .startWith("00")
            .distinctUntilChanged()
    }
    
    func makeTimer() -> Observable<Int> {
        testElement
            .compactMap { $0.element }
            .withLatestFrom(testType) { ($0.timeLeft, $1) }
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
        testType
            .flatMapLatest { [weak self] type -> Observable<String> in
                guard
                    let type = type,
                    let self = self
                else {
                    return .just("00")
                }
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
        testType
            .flatMapLatest { [weak self] type -> Observable<(value: String, isError: Bool)> in
                guard
                    let type = type,
                    let self = self
                else {
                    return .just((value: "00", isError: false))
                }
                
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
    
    var questionAccumulator: ([QuestionElement], ([Question], AnswerElement?)) -> [QuestionElement] {
        return { [weak self] (old, args) -> [QuestionElement] in
            let (questions, answers) = args
            guard !old.isEmpty else {
                return questions.enumerated().map { index, question in
                    let answers = question.answers.map { PossibleAnswerElement(id: $0.id, answer: $0.answer, image: $0.image) }
                    
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
                        questionsCount: questions.count
                    )
                }
            }
            
            guard let currentAnswers = answers, let currentQuestion = questions.first(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            
            guard let index = old.firstIndex(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            let currentElement = old[index]
            let newElements = currentElement.elements.map { value -> TestingCellType in
                guard case .answers = value else { return value }
                
                let result = currentQuestion.answers.map { answer -> AnswerResultElement in
                    let state: AnswerState = currentAnswers.answerIds.contains(answer.id)
                        ? answer.isCorrect ? .correct : .error
                        : answer.isCorrect ? currentQuestion.multiple ? .warning : .correct : .initial
                    
                    return AnswerResultElement(answer: answer.answer, image: answer.image, state: state)
                }
                
                if currentQuestion.multiple {
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
            
            let newElement = QuestionElement(
                id: currentElement.id,
                elements: newElements + explanation,
                isMultiple: currentElement.isMultiple,
                index: currentElement.index,
                isAnswered: currentElement.isAnswered,
                questionsCount: currentElement.questionsCount
            )
            var result = old
            result[index] = newElement
            return result
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
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                return (withoutAnswered[safe: index], questions)
            case .next:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            case .previos:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
}

private extension TestViewModel {
    
    func logAnswerAnalitycs(isCorrect: Bool) {
        guard let type = testType.value, let courseName = courseManager.getSelectedCourse()?.name else {
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
