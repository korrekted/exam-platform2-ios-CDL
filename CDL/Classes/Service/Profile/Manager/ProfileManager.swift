//
//  ProfileManager.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import RxSwift

protocol ProfileManager {
    // MARK: Specific Topic
    func obtainSpecificTopics() -> Single<[SpecificTopic]>
    func obtainSelectedSpecificTopics() -> Single<[SpecificTopic]>
    func saveSelected(specificTopics: [SpecificTopic]) -> Single<Void>
}
