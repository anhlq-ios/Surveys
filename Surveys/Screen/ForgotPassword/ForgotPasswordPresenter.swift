//
//  ForgotPasswordPresenter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/20/21.
//

import Foundation

protocol ForgotPasswordPresentable: Presentable {
    var viewDidLoadRelay: PublishRelay<Void> { get }
    var emailRelay: BehaviorRelay<String> { get }
    var resetTapRelay: PublishRelay<Void> { get }
}

final class ForgotPasswordPresenter: ForgotPasswordPresentable, ForgotPasswordInteractableListener {
    
    private weak var view: ForgotPasswordViewable!
    private let interactor: ForgotPasswordInteractable
    private let router: ForgotPasswordRoutable
    private let disposeBag = DisposeBag()
    
    // MARK: - SurveyListPresentable
    let viewDidLoadRelay = PublishRelay<Void>()
    let emailRelay = BehaviorRelay<String>(value: "")
    let resetTapRelay = PublishRelay<Void>()
    
    init(view: ForgotPasswordViewable, interactor: ForgotPasswordInteractable, router: ForgotPasswordRoutable) {
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
        emailRelay
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: view.isEnableReset)
            .disposed(by: disposeBag)
    }
    
    private func configureInteractor() {
        resetTapRelay.withLatestFrom(emailRelay)
            .subscribe(onNext: { [weak self] (email) in
                self?.view.isShowLoading.accept(true)
                self?.interactor.resetPassword(email: email)
            }).disposed(by: disposeBag)
    }
}

extension ForgotPasswordPresenter {
    func onResetPasswordSuccess() {
        view.isShowLoading.accept(false)
        view.showNotification.accept(())
    }
    
    func onResetPasswordError(_ error: Error) {
        view.isShowLoading.accept(false)
        router.showAlert(title: "Login failed", message: "An error ocurred, please retry again!")
    }
}
