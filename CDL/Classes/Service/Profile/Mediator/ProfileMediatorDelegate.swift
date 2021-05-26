//
//  ProfileMediatorDelegate.swift
//  CDL
//
//  Created by Andrey Chernyshev on 14.05.2021.
//

protocol ProfileMediatorDelegate: class {
    func didSaveSelected(specificTopics: [SpecificTopic])
    func didUpdated(profileLocale: ProfileLocale)
}
