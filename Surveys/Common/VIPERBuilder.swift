//
//  VIPERBuilder.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/25/21.
//

import Foundation
import UIKit

final class VIPERBuilder {
    
    static func buildLogin() -> UIViewController {
        let service = LoginService(alamofireManager: AlamofireManager.shared, keychainManager: KeychainManager.shared)
        let view = LoginViewController.initialInstantiate()
        let interactor = LoginInteractor(loginService: service,
                                         keychainManger: KeychainManager.shared)
        let router = LoginRouter(view: view)
        let presenter = LoginPresenter(view: view,
                                            interactor: interactor,
                                            router: router)
        interactor.presenter = presenter
        return view
    }
    
    static func buildForgotPassword() -> UIViewController {
        let service = LoginService(alamofireManager: AlamofireManager.shared, keychainManager: KeychainManager.shared)
        let view = ForgotPasswordViewController.initialInstantiate()
        let interactor = ForgotPasswordInteractor(loginService: service)
        let router = ForgotPasswordRouter(view: view)
        let presenter = ForgotPasswordPresenter(view: view,
                                            interactor: interactor,
                                            router: router)
        interactor.presenter = presenter
        return view
    }
    
    static func buildSplash() -> UIViewController {
        let view = SplashScreenViewController.initialInstantiate()
        let router = SplashScreenRouter(view: view)
        _ = SplashScreenPresenter(view: view, router: router)
        return view
    }
    
    static func buildSurveyList() -> UIViewController {
        let service = SurveyService(alamofireManager: AlamofireManager.shared)
        let view = SurveyListViewController.initialInstantiate()
        let interactor = SurveyListInteractor(surveyService: service)
        let router = SurveyListRouter(view: view)
        let presenter = SurveyListPresenter(view: view,
                                            interactor: interactor,
                                            router: router)
        interactor.presenter = presenter
        return view
    }
    
    static func buildSurveyDetail(title: String) -> UIViewController {
        let view = SurveyDetailViewController.initialInstantiate()
        view.title = title
        return view
    }
}
