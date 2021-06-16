//
//  BaseService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/16/21.
//

import Foundation
import Alamofire

protocol BaseTarget {
    var baseUrl: String { get }
    var path: String { get }
    var fullUrl: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Encodable { get }
    var parameterEncoder: ParameterEncoder { get }
}

extension BaseTarget {
    var baseUrl: String { Constant.baseUrl }
    var headers: HTTPHeaders { [] }
    var fullUrl: String { return baseUrl + path }
}

protocol BaseInput: Encodable {
    var clientId: String { get }
    var clientSecret: String { get }
}
extension BaseInput {
    var clientId: String { Constant.clientID }
    var clientSecret: String { Constant.clientSecret }
}
