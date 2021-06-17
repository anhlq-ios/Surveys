//
//  LoginService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation
import Alamofire

protocol LoginServiceType: BaseServiceType {
    func login(email: String, password: String)
}

class LoginService: LoginServiceType {
    
    static let shared = LoginService(alamofireManager: AlamofireManager.shared)
    
    let alamofireManger: AlamofireManager
    private init(alamofireManager: AlamofireManager) {
        self.alamofireManger = alamofireManager
    }
    
    func login(email: String, password: String) {
        let onSusscess: ((LoginResponse) -> Void) = { loginResponse in
            print(loginResponse)
        }
        let onError: ((Error) -> Void) = { error in
            print(error.localizedDescription)
        }
        let request = LoginTargets.Login(email: email, password: password)
        alamofireManger.request(for: LoginResponse.self, request: request, parameters: request.parameters, onSucess: onSusscess, onError: onError)
    }
}
