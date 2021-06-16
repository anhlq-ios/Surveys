//
//  LoginService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation
import Alamofire

protocol LoginServiceType {
    func login(email: String, password: String)
}

class LoginService: LoginServiceType {
    static let shared = LoginService()
    
    private init() {}
    
    func login(email: String, password: String) {
        let target = LoginTargets.Login(email: email, password: password)
        AF.request(target.fullUrl,
                   method: target.httpMethod,
                   parameters: target.parameters,
                   encoder: target.parameterEncoder,
                   headers: target.headers).response { data in
                    print(data)
                   }
    }
}
