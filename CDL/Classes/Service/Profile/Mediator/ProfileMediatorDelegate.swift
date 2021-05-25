//
//  ProfileMediatorDelegate.swift
//  CDL
//
//  Created by Andrey Chernyshev on 14.05.2021.
//

typealias ProfileLocale = (countryCode: String?, stateCode: String?, languageCode: String?)

protocol ProfileMediatorDelegate: class {
    func didSaveSelected(specificTopics: [SpecificTopic])
    func didUpdated(profileLocale: ProfileLocale)
}
