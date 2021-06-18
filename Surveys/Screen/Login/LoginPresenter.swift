//
//  LoginPresenter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/18/21.
//

import Foundation

protocol LoginPresentable: Presentable {
    var viewDidLoadRelay: PublishRelay<Void> { get }
    var emailRelay: BehaviorRelay<String> { get }
    var passwordRelay: BehaviorRelay<String> { get }
    var loginTapRelay: PublishRelay<Void> { get }
}

final class LoginPresenter: LoginPresentable, LoginInteractableListener {
    
    private let view: LoginViewable!
    private let interactor: LoginInteractable
    private let router: LoginRoutable
    private let disposeBag = DisposeBag()
    
    let viewDidLoadRelay = PublishRelay<Void>()
    let emailRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    let loginTapRelay = PublishRelay<Void>()
    
    init(view: LoginViewable, interactor: LoginInteractable, router: LoginRoutable) {
        self.view = view
        self.interactor = interactor
        self.router = router
        view.presenter = self
        interactor.presenter = self
        
        configurePresenter()
    }
    
    private func configurePresenter() {
        configureView()
        configureInteractor()
    }
    
    private func configureView() {
        Observable.combineLatest(emailRelay, passwordRelay)
            .map { !($0.0.isEmpty || $0.1.isEmpty) }
            .distinctUntilChanged()
            .bind(to: view.isEnableLogin)
            .disposed(by: disposeBag)
    }
    
    private func configureInteractor() {
        let loginInput = Observable.combineLatest(emailRelay, passwordRelay)
        loginTapRelay.withLatestFrom(loginInput)
            .subscribe(onNext: { [weak self] (email, password) in
                self?.interactor.login(email: email, password: password)
            }).disposed(by: disposeBag)
    }
}

// MARK: - LoginInteractableListener
extension LoginPresenter {
    func onLoginSuccess() {
        print("Login success")
        print(KeychainManager.shared.getValue(for: KeychainKeys.accessToken))
        print(KeychainManager.shared.getValue(for: KeychainKeys.refreshToken))
        router.showAlert(title: "Login succeed", message: "Congratulation!")
    }
    
    func onLoginError(_ error: Error) {
        print(error.localizedDescription)
        router.showAlert(title: "Login failed", message: "An error ocurred, please retry again!")
    }
}
