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
    func resetPassword(email: String, completion: ((LoginError?) -> Void)?)
}

enum LoginError: Error {
    case invalidAuthen
    case unexpectedError
}

class LoginService: LoginServiceType {
    
    let alamofireManger: AlamofireManagerType
    private let keychainManager: KeychainManagerType
    
    init(alamofireManager: AlamofireManagerType,
         keychainManager: KeychainManagerType) {
        self.alamofireManger = alamofireManager
        self.keychainManager = keychainManager
    }
    
    func login(email: String, password: String, completion: ((LoginError?) -> Void)?) {
        let onSusscess: ((LoginResponse) -> Void) = { [weak self] loginResponse in
            self?.saveLoginInfo(email: email, password: password)
            self?.handleLoginResponse(loginResponse, completion: completion)
        }
        let onError: ((Error) -> Void) = { error in
            completion?(.invalidAuthen)
        }
        let request = LoginTargets.Login(email: email, password: password)
        alamofireManger.request(for: LoginResponse.self, request: request, parameters: request.parameters, onSucess: onSusscess, onError: onError)
    }
    
    func resetPassword(email: String, completion: ((LoginError?) -> Void)?) {
        let onSusscess: (() -> Void) = {
            completion?(nil)
        }
        let onError: ((Error) -> Void) = { error in
            completion?(.unexpectedError)
        }
        let request = LoginTargets.ForgotPassword(email: email)
        alamofireManger.request(request: request,
                                parameters: request.parameters,
                                onSucess: onSusscess,
                                onError: onError)
    }
}

// MARK: - Private functions
extension LoginService {
    
    private func handleLoginResponse(_ response: LoginResponse, completion: ((LoginError?) -> Void)?) {
        guard let accessToken = response.accessToken, let refreshToken = response.refreshToken else {
            completion?(.unexpectedError)
            return
        }
        keychainManager.set(value: accessToken, for: KeychainKeys.accessToken)
        keychainManager.set(value: refreshToken, for: KeychainKeys.refreshToken)
        completion?(nil)
    }
    
    private func saveLoginInfo(email: String, password: String) {
        keychainManager.set(value: email, for: KeychainKeys.userName)
        keychainManager.set(value: password, for: KeychainKeys.password)
    }
}
