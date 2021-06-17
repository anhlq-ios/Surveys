//
//  SplashScreenRouter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation

protocol SplashScreenRoutable: Routable {
    func routeToLogin()
}

final class SplashScreenRouter: SplashScreenRoutable {
    var view: Viewable!
    
    init(view: Viewable) {
        self.view = view
    }
    
    func routeToLogin() {
        self.dismiss(animated: false)
        let login = VIPERBuilder.buildLogin()
        UIApplication.shared.keyWindow?.rootViewController = login
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}
