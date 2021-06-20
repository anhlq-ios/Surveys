//
//  ForgotPasswordViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/20/21.
//

import UIKit

protocol ForgotPasswordViewable: Viewable {
    var presenter: ForgotPasswordPresentable! { get set }
    var isEnableReset: BehaviorRelay<Bool> { get }
    var isShowLoading: BehaviorRelay<Bool> { get }
    var showNotification: PublishRelay<Void> { get }
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordViewable {

    var presenter: ForgotPasswordPresentable!
    
    @IBOutlet private weak var customNavigationBar: UINavigationBar!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var snackBar: SnackBar!
    @IBOutlet private weak var snackbarTopLayoutConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private let loadingActivity = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - LoginViewable
    let isEnableReset = BehaviorRelay<Bool>(value: false)
    let isShowLoading = BehaviorRelay<Bool>(value: false)
    let showNotification = PublishRelay<Void>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureViewable()
        configurePresenter()
    }
    
    private func configureView() {
        customNavigationBar.topItem?.title = ""
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        customNavigationBar.isTranslucent = true
        customNavigationBar.backgroundColor = .clear
        customNavigationBar.tintColor = .white
        let backButton = UIBarButtonItem(image: Images.arrowLeft, style: .plain, target: self, action: #selector(backTrigger))
        customNavigationBar.topItem?.setLeftBarButton(backButton, animated: true)
        
        let font = UIFont(name: FontName.neuzeitBookStandard, size: 17) ?? .systemFont(ofSize: 17)
        let attributedKeys = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3),
                              NSAttributedString.Key.font: font]
        
        emailTextField.backgroundColor = .white.withAlphaComponent(0.18)
        emailTextField.layer.cornerRadius = 12
        emailTextField.clipsToBounds = true
        emailTextField.textColor = .white
        emailTextField.font = font
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributedKeys)
        
        resetButton.backgroundColor = .white
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.titleLabel?.font = font
        resetButton.layer.cornerRadius = 12
        
        view.addSubview(loadingActivity)
        loadingActivity.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(resetButton.snp_bottomMargin).offset(20)
        }
        
        snackbarTopLayoutConstraint.constant = -84
        snackBar.isHidden = true
        snackBar.title = "Check your email."
        snackBar.detail = "We’ve email you instructions to reset your password."
    }
    
    private func configureViewable() {
        isEnableReset.asDriver().drive(resetButton.rx.isEnabled).disposed(by: disposeBag)

        isShowLoading.asDriver()
            .drive(loadingActivity.rx.isAnimating).disposed(by: disposeBag)
        
        showNotification.asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in self?.showSnackBar() }).disposed(by: disposeBag)
    }
    
    private func configurePresenter() {
        guard let presenter = presenter else { return }
        emailTextField.rx.text
            .compactMap { $0 }
            .bind(to: presenter.emailRelay)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: presenter.resetTapRelay)
            .disposed(by: disposeBag)
    }
    
    @objc private func backTrigger() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showSnackBar() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.snackBar.isHidden = false
            self?.snackbarTopLayoutConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }, completion: { finish in
            if finish {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.snackbarTopLayoutConstraint.constant = -84
                        self?.snackBar.isHidden = true
                        self?.view.layoutIfNeeded()
                    }
                }
            }
        })
    }
}
