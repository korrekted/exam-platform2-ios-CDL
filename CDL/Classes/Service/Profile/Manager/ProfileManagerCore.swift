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
            
            ProfileMediator.shared.notifyAboutSaveSelected(specificTopics: specificTopics)
            
            return Disposables.create()
        }
    }
}

// MARK: Set
extension ProfileManagerCore {
    func set(country: String? = nil,
             state: String? = nil,
             language: String? = nil,
             topicsIds: [Int]? = nil) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetRequest(userToken: userToken,
                                 country: country,
                                 state: state,
                                 language: language,
                                 topicsIds: topicsIds)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
    }
}
