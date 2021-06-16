//
//  LoginViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import UIKit
import Alamofire

final class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request
    }
}
