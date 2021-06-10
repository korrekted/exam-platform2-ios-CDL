//
//  FlashcardsViewModel.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import RxSwift
import RxCocoa

final class FlashcardsViewModel {
    lazy var flashcardTopicId = BehaviorRelay<Int?>(value: nil)
    
    lazy var flashcards = makeFlashcards()
    
    private lazy var flashcardsManager = FlashcardsManagerCore()
}

// MARK: Private
private extension FlashcardsViewModel {
    func makeFlashcards() -> Driver<[Flashcard]> {
        flashcardTopicId.compactMap { $0 }
            .flatMapLatest { [weak self] flashcardTopicId -> Single<[Flashcard]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.flashcardsManager
                    .obtainFlashcards(flashcardTopicId: flashcardTopicId)
                    .catchAndReturn([])
            }
            .asDriver(onErrorJustReturn: [])
    }
}
