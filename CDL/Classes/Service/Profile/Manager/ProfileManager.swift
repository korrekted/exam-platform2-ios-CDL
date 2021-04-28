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
    
    // MARK: Language
    func saveSelected(language: Language) -> Single<Void>
    func obtainSelectedLanguage() -> Single<Language?>
    
    // MARK: State
    func saveSelected(state: State) -> Single<Void>
    func obtainSelectedState() -> Single<State?>
    
    // MARK: Set
    func set(state: String?,
             language: String?,
             topicsIds: [Int]?) -> Single<Void>
}
