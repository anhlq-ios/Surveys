//
//  LoginRouter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/18/21.
//

import Foundation
import UIKit

protocol LoginRoutable: Routable {
    func showAlert(title: String?, message: String?)
    func routeToSurveyList()
    func routeToForgotPassword()
}

final class LoginRouter: LoginRoutable {
    unowned var view: Viewable
    
    init(view: Viewable) {
        self.view = view
    }
    
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async { [weak view] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
            }
            alert.addAction(action)
            view?.present(alert, animated: true)
        }
    }
    
    func routeToSurveyList() {
        DispatchQueue.main.async {
            let surveyList = VIPERBuilder.buildSurveyList()
            let navigationController = UINavigationController(rootViewController: surveyList)
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        }
    }
    
    func routeToForgotPassword() {
        DispatchQueue.main.async { [weak view] in
            let forgotPassword = VIPERBuilder.buildForgotPassword()
            view?.push(forgotPassword, animated: true)
        }
    }
}
