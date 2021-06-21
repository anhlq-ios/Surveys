//
//  MockLoginRouter.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockLoginRouter: LoginRoutable {

    var invokedViewGetter = false
    var invokedViewGetterCount = 0
    var stubbedView: Viewable!

    var view: Viewable {
        invokedViewGetter = true
        invokedViewGetterCount += 1
        return stubbedView
    }

    var invokedShowAlert = false
    var invokedShowAlertCount = 0
    var invokedShowAlertParameters: (title: String?, message: String?)?
    var invokedShowAlertParametersList = [(title: String?, message: String?)]()

    func showAlert(title: String?, message: String?) {
        invokedShowAlert = true
        invokedShowAlertCount += 1
        invokedShowAlertParameters = (title, message)
        invokedShowAlertParametersList.append((title, message))
    }

    var invokedRouteToSurveyList = false
    var invokedRouteToSurveyListCount = 0

    func routeToSurveyList() {
        invokedRouteToSurveyList = true
        invokedRouteToSurveyListCount += 1
    }

    var invokedRouteToForgotPassword = false
    var invokedRouteToForgotPasswordCount = 0

    func routeToForgotPassword() {
        invokedRouteToForgotPassword = true
        invokedRouteToForgotPasswordCount += 1
    }

    var invokedDismiss = false
    var invokedDismissCount = 0
    var invokedDismissParameters: (animated: Bool, Void)?
    var invokedDismissParametersList = [(animated: Bool, Void)]()

    func dismiss(animated: Bool) {
        invokedDismiss = true
        invokedDismissCount += 1
        invokedDismissParameters = (animated, ())
        invokedDismissParametersList.append((animated, ()))
    }

    var invokedDismissAnimated = false
    var invokedDismissAnimatedCount = 0
    var invokedDismissAnimatedParameters: (animated: Bool, Void)?
    var invokedDismissAnimatedParametersList = [(animated: Bool, Void)]()
    var shouldInvokeDismissAnimatedCompletion = false

    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        invokedDismissAnimated = true
        invokedDismissAnimatedCount += 1
        invokedDismissAnimatedParameters = (animated, ())
        invokedDismissAnimatedParametersList.append((animated, ()))
        if shouldInvokeDismissAnimatedCompletion {
            completion()
        }
    }

    var invokedPop = false
    var invokedPopCount = 0
    var invokedPopParameters: (animated: Bool, Void)?
    var invokedPopParametersList = [(animated: Bool, Void)]()

    func pop(animated: Bool) {
        invokedPop = true
        invokedPopCount += 1
        invokedPopParameters = (animated, ())
        invokedPopParametersList.append((animated, ()))
    }
}
