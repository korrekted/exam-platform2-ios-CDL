//
//  SetRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.04.2021.
//

import Alamofire

struct SetRequest: APIRequestBody {
    private let userToken: String
    private let country: String?
    private let state: String?
    private let language: String?
    private let topicsIds: [Int]?
    
    init(userToken: String,
         country: String? = nil,
         state: String? = nil,
         language: String? = nil,
         topicsIds: [Int]? = nil) {
        self.userToken = userToken
        self.country = country
        self.state = state
        self.language = language
        self.topicsIds = topicsIds
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let country = self.country {
            params["country"] = country
        }
        
        if let state = self.state {
            params["state"] = state
        }
        
        if let language = self.language {
            params["language"] = language
        }
        
        if let topicsIds = self.topicsIds {
            params["course_ids"] = topicsIds
        }
        
        return params
    }
}
