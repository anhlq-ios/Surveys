//
//  SurveyListPresenterTests.swift
//  SurveysTests
//
//  Created by Le Quoc Anh on 6/21/21.
//

import XCTest
@testable import Surveys

class SurveyListPresenterTests: XCTestCase {

    var sut: SurveyListPresenter!
    var interactor: MockSurveyListInteractor!
    var router: MockSurveyListRouter!
    var view: MockSurveyListView!
    var surveyList: [Survey]!
    
    override func setUpWithError() throws {
        view = MockSurveyListView()
        view.stubbedViewModel = BehaviorRelay<SurveyViewModel?>(value: nil)
        view.stubbedIsShowLoading = BehaviorRelay<Bool>(value: false)
        
        interactor = MockSurveyListInteractor()
        router = MockSurveyListRouter()
        sut = SurveyListPresenter(view: view, interactor: interactor, router: router)
        
        surveyList = [Survey(id: "0", title: "Survey 1", description: "Detail survey 1"),
                      Survey(id: "1", title: "Survey 2", description: "Detail survey 2")]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - View did load triggered
    func testViewDidLoadTriggered() throws {
        XCTAssertEqual(view.isShowLoading.value, false)
        
        XCTAssertEqual(interactor.invokedGetSurveyList, false)
        XCTAssertEqual(interactor.invokedGetSurveyListCount, 0)
        
        sut.viewDidLoadRelay.accept(())
        
        /// show loading
        XCTAssertEqual(view.isShowLoading.value, true)
        /// get survey list
        XCTAssertEqual(interactor.invokedGetSurveyList, true)
        XCTAssertEqual(interactor.invokedGetSurveyListCount, 1)
    }
    
    // MARK: - Refresh triggered
    func testRefreshTriggered() throws {
        XCTAssertEqual(view.isShowLoading.value, false)
        
        XCTAssertEqual(interactor.invokedGetSurveyList, false)
        XCTAssertEqual(interactor.invokedGetSurveyListCount, 0)
        
        sut.viewDidLoadRelay.accept(())
        
        /// End loading
        XCTAssertEqual(view.isShowLoading.value, true)
        
        XCTAssertEqual(interactor.invokedGetSurveyList, true)
        XCTAssertEqual(interactor.invokedGetSurveyListCount, 1)
    }
    
    
    // MARK: - Get survey list success
    func testGetSurveyListSuccess() throws {
        XCTAssertEqual(view.invokedViewModelGetter, true)
        XCTAssertEqual(view.invokedViewModelGetterCount, 1)
        
        view.isShowLoading.accept(true)
        sut.onGetListSurveySuccess(surveys: surveyList)
        
        /// End loading
        XCTAssertEqual(view.isShowLoading.value, false)
        
        XCTAssertEqual(view.invokedViewModelGetter, true)
        XCTAssertEqual(view.invokedViewModelGetterCount, 1)
        XCTAssertEqual(view.viewModel.value?.title, surveyList[0].title?.uppercased())
        XCTAssertEqual(view.viewModel.value?.descipton, surveyList[0].description)
    }
    
    // MARK: - Get survey list error
    func testGetSurveyListError() throws {
        view.isShowLoading.accept(true)
        sut.onGetListSurveyError(SurveyListError.unexpectedError)
        
        /// End loading
        XCTAssertEqual(view.isShowLoading.value, false)
    }
    
    // MARK: - Swipe left
    func testSwipeLeft() throws {
        XCTAssertNil(view.viewModel.value)
        
        sut.onGetListSurveySuccess(surveys: surveyList)
        /// Auto select first item
        XCTAssertEqual(view.viewModel.value?.title, surveyList[0].title?.uppercased())
        XCTAssertEqual(view.viewModel.value?.descipton, surveyList[0].description)
        
        sut.swipeDirection.accept(.left)
        
        /// Selected next Item
        XCTAssertEqual(view.viewModel.value?.title, surveyList[1].title?.uppercased())
        XCTAssertEqual(view.viewModel.value?.descipton, surveyList[1].description)
    }
    
    // MARK: - Swipe right
    func testSwipeRight() throws {
        XCTAssertNil(view.viewModel.value)
        
        sut.onGetListSurveySuccess(surveys: surveyList)
        /// Auto select first item
        XCTAssertEqual(view.viewModel.value?.title, surveyList[0].title?.uppercased())
        XCTAssertEqual(view.viewModel.value?.descipton, surveyList[0].description)
        
        sut.swipeDirection.accept(.right)
        
        /// Selected next Item
        XCTAssertEqual(view.viewModel.value?.title, surveyList[1].title?.uppercased())
        XCTAssertEqual(view.viewModel.value?.descipton, surveyList[1].description)
    }
    
    // MARK: - Go to detail
    func testGoToDetail() throws {
        XCTAssertEqual(router.invokedRouteToDetail, false)
        XCTAssertEqual(router.invokedRouteToDetailCount, 0)
        
        sut.onGetListSurveySuccess(surveys: surveyList)
        sut.detailButtonTapped.accept(())
        
        /// Auto select first item
        XCTAssertEqual(router.invokedRouteToDetail, true)
        XCTAssertEqual(router.invokedRouteToDetailCount, 1)
        XCTAssertEqual(router.invokedRouteToDetailParameters?.title, surveyList[0].title)
    }
}
