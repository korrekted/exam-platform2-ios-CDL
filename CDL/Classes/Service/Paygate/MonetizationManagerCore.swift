//
//  MonetizationManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import RxSwift

final class MonetizationManagerCore: MonetizationManager {}

// MARK: Public
extension MonetizationManagerCore {
    // С 49 билда монетизация всегда suggest
    func getMonetizationConfig() -> MonetizationConfig? {
        .suggest
    }
    
    // С 42 билда монетизация всегда suggest
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?> {
        .deferred { .just(.suggest) }
    }
}
