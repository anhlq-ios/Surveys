//
//  SurveyListInteractor.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import Foundation

protocol SurveyListInteractableListener: AnyObject {
    func onGetListSurveySuccess(surveys: [Survey])
    func onGetListSurveyError(_ error: Error)
}

protocol SurveyListInteractable: Interactable {
    var presenter: SurveyListInteractableListener? { get set }
    func getSurveyList()
}

final class SurveyListInteractor: SurveyListInteractable {
    
    weak var presenter: SurveyListInteractableListener?
    
    private let surveyService: SurveyServiceType
    
    init(surveyService: SurveyServiceType) {
        self.surveyService = surveyService
    }
    
    func getSurveyList() {
        surveyService.getSurveyList(page: 1, size: 5) { [weak presenter] surveys, error in
            if let error = error {
                presenter?.onGetListSurveyError(error)
            } else {
                presenter?.onGetListSurveySuccess(surveys: surveys)
            }
        }
    }
}

