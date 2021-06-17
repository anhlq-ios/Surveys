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
        let view = LoginViewController.initialInstantiate()
//        let interactor = CryptoListInteractor()
//        let router = CryptoListRouter(view: view)
//        let presenter = CryptoListPresenter(view: view,
//                                            interactor: interactor,
//                                            router: router)
//        interactor.presenter = presenter
        return view
    }
    
    static func buildSplash() -> UIViewController {
        let view = SplashScreenViewController.initialInstantiate()
        let router = SplashScreenRouter(view: view)
        let presenter = SplashScreenPresenter(view: view,
                                            router: router)
        return view
    }
}
