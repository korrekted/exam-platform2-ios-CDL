//
//  GetTopicsRequest.swift
//  CDL
//
//  Created by Andrey Chernyshev on 28.04.2021.
//

import Alamofire

struct GetTopicsRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/courses/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
