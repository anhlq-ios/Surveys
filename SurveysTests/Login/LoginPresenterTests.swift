//
//  LoginPresenterTests.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/15/21.
//

import XCTest
@testable import Surveys

class LoginPresenterTests: XCTestCase {

    var sut: LoginPresenter!
    var interactor: MockLoginInteractor!
    var router: MockLoginRouter!
    var view: MockLoginView!
    
    override func setUpWithError() throws {
        interactor = MockLoginInteractor()
        router = MockLoginRouter()
        view = MockLoginView()
        view.stubbedIsEnableLogin = BehaviorRelay<Bool>(value: false)
        view.stubbedIsShowLoading = BehaviorRelay<Bool>(value: false)
        sut = LoginPresenter(view: view, interactor: interactor, router: router)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test enable login
    func testViewIsEnableLogin() throws {
        XCTAssertEqual(view.isEnableLogin.value, false)
        
        sut.emailRelay.accept("anhlq.uit@gmail.com")
        sut.passwordRelay.accept("12345678")
        
        XCTAssertEqual(view.isEnableLogin.value, true)
        
        sut.emailRelay.accept("")
        sut.passwordRelay.accept("12345678")
        
        XCTAssertEqual(view.isEnableLogin.value, false)
        
        sut.emailRelay.accept("anhlq.uit@gmail.com")
        sut.passwordRelay.accept("")
        
        XCTAssertEqual(view.isEnableLogin.value, false)
        
        sut.emailRelay.accept("")
        sut.passwordRelay.accept("")
        
        XCTAssertEqual(view.isEnableLogin.value, false)
    }
    
    // MARK: - Login invoked
    func testViewIsShowLoading() throws {
        
        XCTAssertEqual(view.isShowLoading.value, false)
        
        XCTAssertEqual(interactor.invokedLogin, false)
        XCTAssertEqual(interactor.invokedLoginCount, 0)
        
        sut.emailRelay.accept("anhlq.uit@gmail.com")
        sut.passwordRelay.accept("12345678")
        sut.loginTapRelay.accept(())
        
        // View is loading
        XCTAssertEqual(view.isShowLoading.value, true)
        
        // Interactor is call login
        XCTAssertEqual(interactor.invokedLogin, true)
        XCTAssertEqual(interactor.invokedLoginCount, 1)
        XCTAssertEqual(interactor.invokedLoginParameters?.email, "anhlq.uit@gmail.com")
        XCTAssertEqual(interactor.invokedLoginParameters?.password, "12345678")
    }

    // MARK: - Login Success
    func testLoginSuccess() throws {
        
        XCTAssertEqual(router.invokedRouteToSurveyList, false)
        XCTAssertEqual(router.invokedRouteToSurveyListCount, 0)
        
        sut.onLoginSuccess()
        
        /// End loading
        XCTAssertEqual(view.isShowLoading.value, false)
        /// Route to survey list
        XCTAssertEqual(router.invokedRouteToSurveyList, true)
        XCTAssertEqual(router.invokedRouteToSurveyListCount, 1)
    }
    
    // MARK: - Login Error
    func testLoginError() throws {
        view.isShowLoading.accept(true)
        
        XCTAssertEqual(router.invokedShowAlert, false)
        XCTAssertEqual(router.invokedShowAlertCount, 0)
        
        sut.onLoginError(LoginError.invalidAuthen)
        /// End loading
        XCTAssertEqual(view.isShowLoading.value, false)
        /// Show alert
        XCTAssertEqual(router.invokedShowAlert, true)
        XCTAssertEqual(router.invokedShowAlertCount, 1)
        XCTAssertEqual(router.invokedShowAlertParameters?.title, "Login failed")
        XCTAssertEqual(router.invokedShowAlertParameters?.message, "An error ocurred, please retry again!")
    }
    
    // MARK: - Route to forgot password
    func testForgotPassword() throws {
        
        XCTAssertEqual(router.invokedRouteToForgotPassword, false)
        XCTAssertEqual(router.invokedRouteToForgotPasswordCount, 0)
        
        sut.forgotPasswordTap.accept(())
        
        /// Show alert
        XCTAssertEqual(router.invokedRouteToForgotPassword, true)
        XCTAssertEqual(router.invokedRouteToForgotPasswordCount, 1)
    }

}
