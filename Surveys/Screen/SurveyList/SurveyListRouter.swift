//
//  SurveyListRouter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import Foundation

protocol SurveyListRoutable: Routable {
    func routeToDetail(title: String)
}

final class SurveyListRouter: SurveyListRoutable {
    var view: Viewable!
    
    init(view: Viewable) {
        self.view = view
    }
    
    func routeToDetail(title: String) {
        DispatchQueue.main.async { [weak view] in
            let detail = VIPERBuilder.buildSurveyDetail(title: title)
            view?.push(detail, animated: true)
        }
    }
}
