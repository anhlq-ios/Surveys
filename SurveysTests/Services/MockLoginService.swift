//
//  MockLoginService.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockLoginService: LoginServiceType {

    var invokedAlamofireMangerGetter = false
    var invokedAlamofireMangerGetterCount = 0
    var stubbedAlamofireManger: AlamofireManagerType!

    var alamofireManger: AlamofireManagerType {
        invokedAlamofireMangerGetter = true
        invokedAlamofireMangerGetterCount += 1
        return stubbedAlamofireManger
    }

    var invokedLogin = false
    var invokedLoginCount = 0
    var invokedLoginParameters: (email: String, password: String)?
    var invokedLoginParametersList = [(email: String, password: String)]()
    var stubbedLoginCompletionResult: (LoginError?, Void)?

    func login(email: String, password: String, completion: ((LoginError?) -> Void)?) {
        invokedLogin = true
        invokedLoginCount += 1
        invokedLoginParameters = (email, password)
        invokedLoginParametersList.append((email, password))
        if let result = stubbedLoginCompletionResult {
            completion?(result.0)
        }
    }

    var invokedResetPassword = false
    var invokedResetPasswordCount = 0
    var invokedResetPasswordParameters: (email: String, Void)?
    var invokedResetPasswordParametersList = [(email: String, Void)]()
    var stubbedResetPasswordCompletionResult: (LoginError?, Void)?

    func resetPassword(email: String, completion: ((LoginError?) -> Void)?) {
        invokedResetPassword = true
        invokedResetPasswordCount += 1
        invokedResetPasswordParameters = (email, ())
        invokedResetPasswordParametersList.append((email, ()))
        if let result = stubbedResetPasswordCompletionResult {
            completion?(result.0)
        }
    }
}
