//
//  SplashScreenPresenter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation

protocol SplashScreenPresenable: Presentable {
    func didEndAminated()
}

final class SplashScreenPresenter: SplashScreenPresenable {
    private unowned var view: SplashScreenViewable
    private let router: SplashScreenRoutable
    
    init(view: SplashScreenViewable, router: SplashScreenRoutable) {
        self.view = view
        self.router = router
        view.presenter = self
    }
    
    func didEndAminated() {
        router.routeToLogin()
    }
}
