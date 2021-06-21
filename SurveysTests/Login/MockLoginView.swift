//
//  MockLoginView.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import Foundation
@testable import Surveys

final class MockLoginView: LoginViewable {

    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: LoginPresentable?
    var invokedPresenterList = [LoginPresentable?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: LoginPresentable!

    var presenter: LoginPresentable! {
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

    var invokedIsEnableLoginGetter = false
    var invokedIsEnableLoginGetterCount = 0
    var stubbedIsEnableLogin: BehaviorRelay<Bool>!

    var isEnableLogin: BehaviorRelay<Bool> {
        invokedIsEnableLoginGetter = true
        invokedIsEnableLoginGetterCount += 1
        return stubbedIsEnableLogin
    }

    var invokedIsShowLoadingGetter = false
    var invokedIsShowLoadingGetterCount = 0
    var stubbedIsShowLoading: BehaviorRelay<Bool>!

    var isShowLoading: BehaviorRelay<Bool> {
        invokedIsShowLoadingGetter = true
        invokedIsShowLoadingGetterCount += 1
        return stubbedIsShowLoading
    }

    var invokedPush = false
    var invokedPushCount = 0
    var invokedPushParameters: (vc: UIViewController, animated: Bool)?
    var invokedPushParametersList = [(vc: UIViewController, animated: Bool)]()

    func push(_ vc: UIViewController, animated: Bool) {
        invokedPush = true
        invokedPushCount += 1
        invokedPushParameters = (vc, animated)
        invokedPushParametersList.append((vc, animated))
    }

    var invokedPresent = false
    var invokedPresentCount = 0
    var invokedPresentParameters: (vc: UIViewController, animated: Bool)?
    var invokedPresentParametersList = [(vc: UIViewController, animated: Bool)]()

    func present(_ vc: UIViewController, animated: Bool) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (vc, animated)
        invokedPresentParametersList.append((vc, animated))
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
    var shouldInvokeDismissAnimated_completion = false

    func dismiss(animated: Bool, _completion:  @escaping (() -> Void)) {
        invokedDismissAnimated = true
        invokedDismissAnimatedCount += 1
        invokedDismissAnimatedParameters = (animated, ())
        invokedDismissAnimatedParametersList.append((animated, ()))
        if shouldInvokeDismissAnimated_completion {
            _completion()
        }
    }
}
