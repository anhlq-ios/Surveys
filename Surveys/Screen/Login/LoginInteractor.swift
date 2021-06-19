//
//  LoginInteractor.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/18/21.
//

import Foundation

protocol LoginInteractableListener: AnyObject {
    func onLoginSuccess()
    func onLoginError(_ error: Error)
}

protocol LoginInteractable: Interactable {
    var presenter: LoginInteractableListener? { get set }
    func login(email: String, password: String)
    func loginAutomated()
}

final class LoginInteractor: LoginInteractable {
    weak var presenter: LoginInteractableListener?
    
    private let loginService: LoginServiceType
    private let keychainManger: KeychainManagerType
    
    init(loginService: LoginServiceType, keychainManger: KeychainManagerType) {
        self.loginService = loginService
        self.keychainManger = keychainManger
    }
    
    func login(email: String, password: String) {
        loginService.login(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.presenter?.onLoginError(error)
            } else {
                self?.presenter?.onLoginSuccess()
            }
        }
    }
    
    func loginAutomated() {
        let email = keychainManger.getValue(for: KeychainKeys.userName) ?? ""
        let password = keychainManger.getValue(for: KeychainKeys.password) ?? ""
        loginService.login(email: email, password: password) { [weak self] error in
            if let error = error {
                self?.presenter?.onLoginError(error)
            } else {
                self?.presenter?.onLoginSuccess()
            }
        }
    }
}

