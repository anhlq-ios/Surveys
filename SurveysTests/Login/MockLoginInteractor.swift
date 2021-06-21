//
//  MockLoginInteractor.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockLoginInteractor: LoginInteractable {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: LoginInteractableListener?
    var invokedPresenterList = [LoginInteractableListener?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: LoginInteractableListener!

    var presenter: LoginInteractableListener? {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
        }
    }

    var invokedLogin = false
    var invokedLoginCount = 0
    var invokedLoginParameters: (email: String, password: String)?
    var invokedLoginParametersList = [(email: String, password: String)]()

    func login(email: String, password: String) {
        invokedLogin = true
        invokedLoginCount += 1
        invokedLoginParameters = (email, password)
        invokedLoginParametersList.append((email, password))
    }

    var invokedLoginAutomated = false
    var invokedLoginAutomatedCount = 0

    func loginAutomated() {
        invokedLoginAutomated = true
        invokedLoginAutomatedCount += 1
    }
}
