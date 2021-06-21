//
//  MockSurveyListRouter.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockSurveyListRouter: SurveyListRoutable {

    var invokedViewGetter = false
    var invokedViewGetterCount = 0
    var stubbedView: Viewable!

    var view: Viewable {
        invokedViewGetter = true
        invokedViewGetterCount += 1
        return stubbedView
    }

    var invokedRouteToDetail = false
    var invokedRouteToDetailCount = 0
    var invokedRouteToDetailParameters: (title: String, Void)?
    var invokedRouteToDetailParametersList = [(title: String, Void)]()

    func routeToDetail(title: String) {
        invokedRouteToDetail = true
        invokedRouteToDetailCount += 1
        invokedRouteToDetailParameters = (title, ())
        invokedRouteToDetailParametersList.append((title, ()))
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
