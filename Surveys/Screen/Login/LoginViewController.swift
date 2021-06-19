//
//  LoginViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import UIKit
import Alamofire
import SnapKit

protocol LoginViewable: Viewable {
    var presenter: LoginPresentable! { get set }
    var isEnableLogin: BehaviorRelay<Bool> { get }
    var isShowLoading: BehaviorRelay<Bool> { get }
}

final class LoginViewController: UIViewController, LoginViewable {

    var presenter: LoginPresentable!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let loadingActivity = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - LoginViewable
    let isEnableLogin = BehaviorRelay<Bool>(value: false)
    let isShowLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            presenter.viewDidLoadRelay.accept(())
        }
        configureView()
        configureViewable()
        configurePresenter()
    }
    
    private func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let font = UIFont(name: FontName.neuzeitBookStandard, size: 17) ?? .systemFont(ofSize: 17)
        let attributedKeys = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3),
                              NSAttributedString.Key.font: font]
        
        emailTextField.backgroundColor = .white.withAlphaComponent(0.18)
        emailTextField.layer.cornerRadius = 12
        emailTextField.clipsToBounds = true
        emailTextField.textColor = .white
        emailTextField.font = font
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributedKeys)
        
        passwordTextField.backgroundColor = .white.withAlphaComponent(0.18)
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .white
        passwordTextField.font = font
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributedKeys)
        passwordTextField.rightView = makeForgotPasswordLabel(text: "Forgot?", font: font)
        passwordTextField.rightViewMode = .always
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = font
        loginButton.layer.cornerRadius = 12
        
        view.addSubview(loadingActivity)
        loadingActivity.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp_bottomMargin).offset(20)
        }
    }
    
    private func configureViewable() {
        isEnableLogin.asDriver().drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        isShowLoading.asDriver()
            .drive(loadingActivity.rx.isAnimating).disposed(by: disposeBag)
    }
    
    private func configurePresenter() {
        guard let presenter = presenter else { return }
        emailTextField.rx.text
            .compactMap { $0 }
            .bind(to: presenter.emailRelay)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .compactMap { $0 }
            .bind(to: presenter.passwordRelay)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: presenter.loginTapRelay)
            .disposed(by: disposeBag)
    }
    
    private func makeForgotPasswordLabel(text: String?, font: UIFont) -> UIButton {
       let forgotLabel = UIButton()
        forgotLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 16)
        forgotLabel.titleLabel?.font = font
        forgotLabel.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        forgotLabel.setTitle(text, for: .normal)
        return forgotLabel
    }
}
