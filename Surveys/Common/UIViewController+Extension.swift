//
//  UIViewController+Extension.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import UIKit

extension UIViewController {
    static func initialInstantiate() -> Self {
        let storyBoard = UIStoryboard(name: String(describing: Self.self), bundle: nil)
        if #available(iOS 13.0, *) {
            return storyBoard.instantiateInitialViewController() ?? Self()
        } else {
            return storyBoard.instantiateInitialViewController() as! Self
        }
    }
}
