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
    func set(topicsIds: [Int]?) -> Single<Void>
    
    // MARK: Counties
    func retrieveCountries(forceUpdate: Bool) -> Single<[Country]>
    
    // MARK: Profile locale
    func obtainProfileLocale() -> Single<ProfileLocale?>
    func set(country: String?,
             state: String?,
             language: String?) -> Single<Void>
    
    // MARK: Study
    func set(level: Int?,
             assetsPreferences: [Int]?,
             examDate: String?,
             testMinutes: Int?,
             testNumber: Int?,
             testWhen: [Int]?,
             notificationKey: String?) -> Single<Void>
    
    // MARK: Test Mode
    func set(testMode: Int) -> Single<Void>
    func obtainTestMode() -> Single<TestMode?>
    
    func globalSet(level: Int?,
                   assetsPreferences: [Int]?,
                   examDate: String?,
                   testMinutes: Int?,
                   testNumber: Int?,
                   testWhen: [Int]?,
                   notificationKey: String?,
                   country: String?,
                   state: String?,
                   language: String?,
                   testMode: Int?,
                   topicsIds: [Int]?) -> Single<Void>
}
