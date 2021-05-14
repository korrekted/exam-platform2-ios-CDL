//
//  ProfileMediator.swift
//  CDL
//
//  Created by Andrey Chernyshev on 14.05.2021.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private lazy var saveSelectedTopicsTrigger = PublishRelay<[SpecificTopic]>()
    private lazy var saveSelectedLanguageTrigger = PublishRelay<Language>()
    private lazy var saveStateTrigger = PublishRelay<State>()
    
    private init() {}
}

// MARK: API
extension ProfileMediator {
    func notifyAboutSaveSelected(specificTopics: [SpecificTopic]) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didSaveSelected(specificTopics: specificTopics)
            }
            
            self?.saveSelectedTopicsTrigger.accept(specificTopics)
        }
    }
    
    func notifyAboutSaveSelected(language: Language) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didSaveSelected(language: language)
            }
            
            self?.saveSelectedLanguageTrigger.accept(language)
        }
    }
    
    func notifyAboutSaveState(state: State) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didSaveState(state: state)
            }
            
            self?.saveStateTrigger.accept(state)
        }
    }
}

// MARK: Triggers(Rx)
extension ProfileMediator {
    var rxSelectedTopics: Signal<[SpecificTopic]> {
        saveSelectedTopicsTrigger.asSignal()
    }
    
    var rxSelectedLanguage: Signal<Language> {
        saveSelectedLanguageTrigger.asSignal()
    }
    
    var rxSavedState: Signal<State> {
        saveStateTrigger.asSignal()
    }
}

// MARK: Observer
extension ProfileMediator {
    func add(delegate: ProfileMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ProfileMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: ProfileMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
