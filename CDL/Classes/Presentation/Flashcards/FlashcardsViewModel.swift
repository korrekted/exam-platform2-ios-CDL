//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsViewModel {
    lazy var courseId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcardsTopics = makeFlashcardsTopics()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
}

// MARK: Private
private extension FlashcardsViewModel {
    func makeFlashcardsTopics() -> Driver<[FlashcardTopic]> {
        courseId.compactMap { $0 }
            .flatMapLatest { [weak self] courseId -> Single<[FlashcardTopic]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.flashcardsManager
                    .obtainTopics(courseId: courseId)
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
    }
}
