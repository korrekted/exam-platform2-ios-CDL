//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, course, paygate
    }
    
    private lazy var monetizationManager = MonetizationManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    
    func step() -> Driver<Step> {
        library()
            .andThen(makeStep())
            .asDriver(onErrorDriveWith: .empty())
    }
    
    /// Вызывается в методе делегата PaygateViewControllerDelegate для определения, какой экран открыть после закрытия пейгейта. Отличается от makeStep тем, что не учитывает повторное открытие пейгейта.
    func stepAfterPaygateClosed() -> Step {
        guard OnboardingViewController.wasViewed() else {
            return .onboarding
        }
        
        return .course
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Completable {
        monetizationManager
            .rxRetrieveMonetizationConfig(forceUpdate: true)
            .catchAndReturn(nil)
            .asCompletable()
    }
    
    func makeStep() -> Observable<Step> {
        guard OnboardingViewController.wasViewed() else {
            return .deferred { .just(.onboarding) }
        }
        
        if needPayment() {
            return .deferred { .just(.paygate) }
        }
        
        return .deferred { .just(.course) }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.getSession()?.activeSubscription ?? false
        return !activeSubscription
    }
}
