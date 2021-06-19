//
//  Constant.swift
//  CryptoWalletVIPER
//
//  Created by Le Quoc Anh on 5/26/21.
//

import Foundation
import UIKit

enum KeychainKeys {
    static let userName = "user_name"
    static let password = "password"
    static let accessToken = "access_token"
    static let refreshToken = "refresh_token"
}

enum ColorName {
    static let backgroundColor = "backgroundColor"
    static let lightTextColor = "lightTextColor"
    static let textColor = "textColor"
}

enum Constant {
    static let baseUrl = "https://survey-api.nimblehq.co"
    static let clientID = "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE"
    static let clientSecret = "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
}

enum Images {
    static let logo = UIImage(named:"logo")
    static let backgroundImage = UIImage(named:"background_image")
    static let backgroundOverlay = UIImage(named:"background_overlay")
    static let loginBackground = UIImage(named:"login_background_overlay")
    static let arrowRight = UIImage(named: "arrow_right")
}

enum FontName {
    static let neuzeitBookRegular = "NeuzeitSLT-Book"
    static let neuzeitBookStandard = "NeuzeitSLTStd-Book"
    static let neuzeitBookHeavy = "NeuzeitSLTStd-BookHeavy"
}
