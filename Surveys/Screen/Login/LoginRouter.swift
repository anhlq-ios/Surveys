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
}

final class LoginRouter: LoginRoutable {
    var view: Viewable!
    
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
}
