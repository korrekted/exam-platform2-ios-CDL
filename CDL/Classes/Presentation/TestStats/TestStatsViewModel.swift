//
//  TestStatsViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import RxSwift
import RxCocoa

final class TestStatsViewModel {
    lazy var userTestId = BehaviorRelay<Int?>(value: nil)
    lazy var testType = BehaviorRelay<TestType?>(value: nil)
    lazy var filterRelay = PublishRelay<TestStatsFilter>()
    lazy var tryAgainIsHidden = tryAgainIsHiddenRelay.asDriver()
        
    lazy var courseName = makeCourseName()
    lazy var elements = makeElements()
    lazy var testName = makeTestName()
    
    private lazy var testStatsManager = TestStatsManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var tryAgainIsHiddenRelay = BehaviorRelay<Bool>(value: true)
}

// MARK: Private
private extension TestStatsViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .rxGetSelectedCourse()
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeElements() -> Driver<[TestStatsCellType]> {
        let stats = userTestId
            .compactMap { $0 }
            .flatMapLatest { [weak self] userTestId -> Observable<TestStats?> in
                guard let self = self else { return .empty() }
                
                return self.testStatsManager
                    .retrieve(userTestId: userTestId)
                    .asObservable()
                    .catchAndReturn(nil)
            }
            .asObservable()
        
        return Observable
            .combineLatest(stats, filterRelay.asObservable())
            .map { [tryAgainIsHiddenRelay] element, filter -> [TestStatsCellType] in
                guard let stats = element else { return [] }
                
                tryAgainIsHiddenRelay.accept(stats.passed)
                
                let initial: [TestStatsCellType] = [
                    .progress(.init(stats: stats)),
                    .comunityResult(.init(stats: stats)),
                    .description(.init(stats: stats)),
                    .filter(filter)
                ]
                
                return stats.questions
                    .reduce(into: initial) { old, question in
                        switch filter {
                        case .all:
                            old.append(.answer(.init(answer: question)))
                        case .incorrect:
                            if !question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        case .correct:
                            if question.correct {
                                old.append(.answer(.init(answer: question)))
                            } else {
                                break
                            }
                        }
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeTestName() -> Driver<String> {
        testType
            .map { $0?.name ?? "" }
            .asDriver(onErrorJustReturn: "")
    }
}


