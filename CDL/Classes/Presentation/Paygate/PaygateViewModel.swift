//
//  PaygateViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    enum Config {
        case block, suggest
    }
    
    struct PaygateStruct {
        let paygate: Paygate?
        let monetizationConfig: Config
    }
    
    let buy = PublishRelay<String>()
    let restore = PublishRelay<String>()

    lazy var buyed = createBuyed()
    lazy var restored = createRestored()
    
    lazy var processing = RxActivityIndicator()
    
    lazy var paygate = makeData()
    
    private lazy var paygateManager = PaygateManagerCore()
    private lazy var purchaseInteractor = SDKStorage.shared.purchaseInteractor
    private lazy var monetizatiionManager = MonetizationManagerCore()
}

// MARK: Private
private extension PaygateViewModel {
    func makeData() -> Driver<PaygateStruct> {
        return Driver<PaygateStruct>
            .zip(
                makePaygate(),
                makeMonetizationConfig()
            ) { paygate, config -> PaygateStruct in
                PaygateStruct(paygate: paygate,
                              monetizationConfig: config)
            }
    }
}


// MARK: Private (Monetization)
private extension PaygateViewModel {
    func makeMonetizationConfig() -> Driver<Config> {
        guard let conf = monetizatiionManager.getMonetizationConfig() else {
            return .deferred { .just(.suggest) }
        }
        
        switch conf {
        case .block:
            return .deferred { .just(.block) }
        case .suggest:
            return .deferred { .just(.suggest) }
        }
    }
}

// MARK: Private (Get paygate content)
private extension PaygateViewModel {
    func makePaygate() -> Driver<Paygate?> {
        let paygate = paygateManager
            .retrievePaygate()
            .asDriver(onErrorJustReturn: nil)
        
        let prices = paygate
            .flatMapLatest { [paygateManager, processing] response -> Driver<PaygateMapper.PaygateResponse?> in
                guard let response = response else {
                    return .deferred { .just(nil) }
                }
                
                return paygateManager
                    .prepareProductsPrices(for: response)
                    .trackActivity(processing)
                    .asDriver(onErrorJustReturn: nil)
            }
        
        return prices
            .map { $0?.paygate }
    }
}

// MARK: Private (Make purchase)
private extension PaygateViewModel {
    func createBuyed() -> Signal<Bool> {
        let purchase = buy
            .flatMapLatest { [purchaseInteractor, processing] productId -> Observable<Bool> in
                purchaseInteractor
                    .makeActiveSubscriptionByBuy(productId: productId)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response != nil
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(processing)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
    
    func createRestored() -> Signal<Bool> {
        let purchase = restore
            .flatMapLatest { [purchaseInteractor, processing] productId -> Observable<Bool> in
                purchaseInteractor
                    .makeActiveSubscriptionByRestore()
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response != nil
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(processing)
                    .catchAndReturn(false)
            }
        
        return purchase
            .asSignal(onErrorJustReturn: false)
    }
}
