//
//  LoginViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import UIKit
import Alamofire

protocol LoginViewable: Viewable {
    var presenter: LoginPresentable! { get set }
    var isEnableLogin: BehaviorRelay<Bool> { get }
}

final class LoginViewController: UIViewController, LoginViewable {

    var presenter: LoginPresentable!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - LoginViewable
    let isEnableLogin = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewable()
        configurePresenter()
    }
    
    private func configureView() {
        emailTextField.backgroundColor = .white.withAlphaComponent(0.18)
        emailTextField.layer.cornerRadius = 12
        emailTextField.clipsToBounds = true
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        
        passwordTextField.backgroundColor = .white.withAlphaComponent(0.18)
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 12
    }
    
    private func configureViewable() {
        isEnableLogin.asDriver().drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
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
}
