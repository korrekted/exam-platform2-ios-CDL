//
//  Single+Utils.swift
//  CDL
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import RxSwift

extension PrimitiveSequenceType where Trait == SingleTrait {
    func mapToVoid() -> Single<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
