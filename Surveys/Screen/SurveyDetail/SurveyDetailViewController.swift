//
//  SurveyDetailViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import UIKit

class SurveyDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction private func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
