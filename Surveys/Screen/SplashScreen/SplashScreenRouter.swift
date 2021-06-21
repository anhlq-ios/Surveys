//
//  SplashScreenRouter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation
import UIKit

protocol SplashScreenRoutable: Routable {
    func routeToLogin()
}

final class SplashScreenRouter: SplashScreenRoutable {
    unowned var view: Viewable
    
    init(view: Viewable) {
        self.view = view
    }
    
    func routeToLogin() {
        self.dismiss(animated: false)
        let login = VIPERBuilder.buildLogin()
        let navigationController = UINavigationController(rootViewController: login)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
