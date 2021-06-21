//
//  MockSurveyListInteractor.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockSurveyListInteractor: SurveyListInteractable {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: SurveyListInteractableListener?
    var invokedPresenterList = [SurveyListInteractableListener?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: SurveyListInteractableListener!

    var presenter: SurveyListInteractableListener? {
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

    var invokedGetSurveyList = false
    var invokedGetSurveyListCount = 0

    func getSurveyList() {
        invokedGetSurveyList = true
        invokedGetSurveyListCount += 1
    }
}
