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
    }
    
    struct Login: BaseTarget {
                
        var httpMethod: HTTPMethod = .post
        
        var path: String { return "/api/v1/oauth/token" }

        let parameterEncoder: ParameterEncoder = URLEncodedFormParameterEncoder(destination: .httpBody)
        
        var parameters: Encodable {
            
            return LoginInput(email: email, password: password)
        }

        let email: String
        let password: String
    }
}
