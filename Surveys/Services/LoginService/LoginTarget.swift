//
//  LoginTarget.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation
import Alamofire

enum LoginTargets {

    struct LoginInput: BaseInput {
        let email: String
        let password: String
        let grantType: String = "password"
        
        enum CodingKeys: String, CodingKey {
            case email, password
            case grantType = "grant_type"
            case clientId = "client_id"
            case clientSecret = "client_secret"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(email, forKey: .email)
            try container.encode(password, forKey: .password)
            try container.encode(grantType, forKey: .grantType)
            try container.encode(clientId, forKey: .clientId)
            try container.encode(clientSecret, forKey: .clientSecret)
        }
    }
    
    struct Login: BaseTarget {
        
        typealias T = LoginInput
        var parameters: T? {
            return LoginInput(email: email, password: password)
        }
        
        var httpMethod: HTTPMethod = .post
        
        var path: String { return "/api/v1/oauth/token" }

        let parameterEncoder: ParameterEncoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        let email: String
        let password: String
    }
}
