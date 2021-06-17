//
//  LoginResponse.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String?
    let tokenType: String?
    let expriresIn: Int?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expries_in"
        case refreshToken = "refresh_token"
    }
    enum AttributesCodingKeys: String, CodingKey {
        case attributes
    }
    enum DataCodingKeys: String, CodingKey {
        case data
    }
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: DataCodingKeys.self)
        let container = try data.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .data)
        let subcontainer = try container.nestedContainer(keyedBy: CodingKeys.self,
                                                     forKey: .attributes)
        accessToken = try subcontainer.decodeIfPresent(String.self, forKey: .accessToken)
        tokenType = try subcontainer.decodeIfPresent(String.self, forKey: .tokenType)
        expriresIn = try subcontainer.decodeIfPresent(Int.self, forKey: .expiresIn)
        refreshToken = try subcontainer.decodeIfPresent(String.self, forKey: .refreshToken)
    }
}
