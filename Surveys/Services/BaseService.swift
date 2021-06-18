//
//  BaseService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation
import Alamofire

protocol BaseServiceType {
    var alamofireManger: AlamofireManagerType { get }
    var keychainManager: KeychainManagerType { get }
}
