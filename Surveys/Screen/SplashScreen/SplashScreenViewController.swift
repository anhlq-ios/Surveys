//
//  SplashScreenViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import UIKit

protocol SplashScreenViewable: Viewable {
    var presenter: SplashScreenPresenable! { get set }
}

final class SplashScreenViewController: UIViewController, SplashScreenViewable {
    var presenter: SplashScreenPresenable!

    @IBOutlet private weak var logoImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.alpha = 0.1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstAnimation: () -> Void = { [weak self] in
            
            self?.logoImage.alpha = 1
            self?.view.setNeedsLayout()
        }
        let completion: ((Bool) -> Void) = { [weak self] end in
            if end { self?.presenter.didEndAminated() }
                         }
        UIView.animate(withDuration: 0.3, animations: firstAnimation, completion: completion)
    }
}
