//
//  Observable+Utils.swift
//  CDL
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ -> Void in
            Void()
        }
    }
}
