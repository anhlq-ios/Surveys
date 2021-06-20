//
//  ForgotPasswordInteractor.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/20/21.
//

import Foundation

protocol ForgotPasswordInteractableListener: AnyObject {
    func onResetPasswordSuccess()
    func onResetPasswordError(_ error: Error)
}

protocol ForgotPasswordInteractable: Interactable {
    var presenter: ForgotPasswordInteractableListener? { get set }
    func resetPassword(email: String)
}

final class ForgotPasswordInteractor: ForgotPasswordInteractable {
    
    weak var presenter: ForgotPasswordInteractableListener?
    
    private let loginService: LoginServiceType
    
    init(loginService: LoginServiceType) {
        self.loginService = loginService
    }
    
    func resetPassword(email: String) {
        loginService.resetPassword(email: email) { [weak self] error in
            if let error = error {
                self?.presenter?.onResetPasswordError(error)
            } else {
                self?.presenter?.onResetPasswordSuccess()
            }
        }
    }
}

