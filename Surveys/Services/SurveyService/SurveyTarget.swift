//
//  SurveyTarget.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import Foundation
import Alamofire

enum SurveyTargets {

    struct SurveyList: BaseAuthenticateTarget {
        
        typealias T = [String: Int]
        
        let httpMethod: HTTPMethod = .get
        
        var path: String { return "/api/v1/surveys" }

        let parameterEncoder: ParameterEncoder = URLEncodedFormParameterEncoder(destination: .queryString)
        
        var parameters: T? {
            return ["page[number]": pageNumber,
                    "page[size]": size]
        }
        
        let pageNumber: Int
        let size: Int
    }
}
