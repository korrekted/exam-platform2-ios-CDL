//
//  ProfileManagerCore.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import RxSwift

final class ProfileManagerCore {
    enum Constants {
        static let cachedSelectedSpecificTopicsKey = "cachedSelectedSpecificTopicsKey"
        static let cachedSelectedLanguageKey = "cachedSelectedLanguageKey"
        static let cachedSelectedStateKey = "cachedSelectedStateKey"
    }
}

// MARK: Specific Topic
extension ProfileManagerCore {
    func obtainSpecificTopics() -> Single<[SpecificTopic]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetTopicsRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTopicsResponseMapper.map(from:))
    }
    
    func obtainSelectedSpecificTopics() -> Single<[SpecificTopic]> {
        Single<[SpecificTopic]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.cachedSelectedSpecificTopicsKey) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let array = try? JSONDecoder().decode([SpecificTopic].self, from: data)
            
            event(.success(array ?? []))
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
    
    func saveSelected(specificTopics: [SpecificTopic]) -> Single<Void> {
        Single<Void>.create { event in
            guard let data = try? JSONEncoder().encode(specificTopics) else {
                return Disposables.create()
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedSelectedSpecificTopicsKey)
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
}

// MARK: Language
extension ProfileManagerCore {
    func saveSelected(language: Language) -> Single<Void> {
        Single<Void>.create { event in
            guard let data = try? JSONEncoder().encode(language) else {
                return Disposables.create()
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedSelectedLanguageKey)
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainSelectedLanguage() -> Single<Language?> {
        Single<Language?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.cachedSelectedLanguageKey) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let result = try? JSONDecoder().decode(Language.self, from: data)
            
            event(.success(result))
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: State
extension ProfileManagerCore {
    func saveSelected(state: State) -> Single<Void> {
        Single<Void>.create { event in
            guard let data = try? JSONEncoder().encode(state) else {
                return Disposables.create()
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedSelectedStateKey)
            
            event(.success(Void()))
            
            return Disposables.create()
        }
    }
    
    func obtainSelectedState() -> Single<State?> {
        Single<State?>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.cachedSelectedStateKey) else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let result = try? JSONDecoder().decode(State.self, from: data)
            
            event(.success(result))
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
}

// MARK: Set
extension ProfileManagerCore {
    func set(state: String? = nil,
             language: String? = nil,
             topicsIds: [Int]? = nil) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetRequest(userToken: userToken,
                                 state: state,
                                 language: language,
                                 topicsIds: topicsIds)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
    }
}
