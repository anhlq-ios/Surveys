//
//  SurveyService.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import Foundation
import Alamofire

protocol SurveyServiceType: BaseServiceType {
    func getSurveyList(page: Int, size: Int, completion: (([Survey], Error?) -> Void)?)
}

enum SurveyListError: Error {
    case invalidAuthen
    case unexpectedError
}

class SurveyService: SurveyServiceType {
    
    let alamofireManger: AlamofireManagerType
    
    init(alamofireManager: AlamofireManagerType) {
        self.alamofireManger = alamofireManager
    }
    
    func getSurveyList(page: Int, size: Int, completion: (([Survey], Error?) -> Void)?) {
        let onSucess: ((SurveyList) -> Void) = { surveyList in
            completion?(surveyList.surveys ?? [], nil)
        }
        
        let onError: ((Error) -> Void) = { [weak self] error in
            self?.handleError(error, completion: completion)
        }
        
        let request = SurveyTargets.SurveyList(pageNumber: page, size: size)
        alamofireManger.authenticateRequest(for: SurveyList.self,
                                            request: request,
                                            parameters: request.parameters, onSucess: onSucess, onError: onError)
    }
    
    private func handleError(_ error: Error, completion: (([Survey], Error?) -> Void)?) {
        if let afError = error as? AFError {
            completion?([],afError)
        } else {
            completion?([],SurveyListError.unexpectedError)
        }
    }
}
