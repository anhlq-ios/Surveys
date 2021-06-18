//
//  LoginService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation
import Alamofire

protocol LoginServiceType: BaseServiceType {
    func login(email: String, password: String, completion: ((LoginError?) -> Void)?)
}

enum LoginError: Error {
    case invalidAuthen
    case unexpectedError
}

class LoginService: LoginServiceType {
    
    static let shared = LoginService(alamofireManager: AlamofireManager.shared, keychainManager: KeychainManager.shared)
    
    let alamofireManger: AlamofireManagerType
    let keychainManager: KeychainManagerType
    
    private init(alamofireManager: AlamofireManagerType,
                 keychainManager: KeychainManagerType) {
        self.alamofireManger = alamofireManager
        self.keychainManager = keychainManager
    }
    
    func login(email: String, password: String, completion: ((LoginError?) -> Void)?) {
        let onSusscess: ((LoginResponse) -> Void) = { [weak self] loginResponse in
            self?.handleLoginResponse(loginResponse, completion: completion)
        }
        let onError: ((Error) -> Void) = { error in
            completion?(.invalidAuthen)
        }
        let request = LoginTargets.Login(email: email, password: password)
        alamofireManger.request(for: LoginResponse.self, request: request, parameters: request.parameters, onSucess: onSusscess, onError: onError)
    }
    
    private func handleLoginResponse(_ response: LoginResponse, completion: ((LoginError?) -> Void)?) {
        guard let accessToken = response.accessToken, let refreshToken = response.refreshToken else {
            completion?(.unexpectedError)
            return
        }
        keychainManager.set(value: accessToken, for: KeychainKeys.accessToken)
        keychainManager.set(value: refreshToken, for: KeychainKeys.refreshToken)
        completion?(nil)
    }
}
