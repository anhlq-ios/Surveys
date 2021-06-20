//
//  SurveyListPresenter.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import Foundation
import Kingfisher

struct SurveyViewModel {
    let title: String
    let descipton: String
    let image: String
    let currentPage: Int
    let numberPage: Int
}

protocol SurveyListPresentable: Presentable {
    var viewDidLoadRelay: PublishRelay<Void> { get }
    var swipeDirection: PublishRelay<UISwipeGestureRecognizer.Direction> { get }
    var detailButtonTapped: PublishRelay<Void> { get }
    var refreshRelay: PublishRelay<Void> { get }
}

final class SurveyListPresenter: SurveyListPresentable, SurveyListInteractableListener {
    
    private weak var view: SurveyListViewable!
    private let interactor: SurveyListInteractable
    private let router: SurveyListRoutable
    private let disposeBag = DisposeBag()
    
    private var surveys = BehaviorRelay<[Survey]>(value: [])
    private let currentIndex = BehaviorRelay<Int>(value: 0)
    
    // MARK: - SurveyListPresentable
    let viewDidLoadRelay = PublishRelay<Void>()
    let swipeDirection = PublishRelay<UISwipeGestureRecognizer.Direction>()
    let detailButtonTapped = PublishRelay<Void>()
    let refreshRelay = PublishRelay<Void>()
    
    init(view: SurveyListViewable, interactor: SurveyListInteractable, router: SurveyListRoutable) {
        self.view = view
        self.interactor = interactor
        self.router = router
        view.presenter = self
        interactor.presenter = self
        
        configurePresenter()
    }
    
    deinit {
        print("\(Self.self) is deinit")
    }
    
    private func configurePresenter() {
        configureView()
        configureInteractor()
    }

    private func configureView() {
        Observable.combineLatest(surveys.asObservable(), currentIndex.asObservable())
            .filter { $0.0.count > $0.1 }
            .map { (surveys, index) -> SurveyViewModel in
                let survey = surveys[min(index, surveys.count)]
                return SurveyViewModel(title: survey.title ?? "",
                                       descipton: survey.description ?? "",
                                       image: survey.coverImageUrl ?? "",
                                       currentPage: index,
                                       numberPage: surveys.count)
            }
            .bind(to: view.viewModel)
            .disposed(by: disposeBag)
    }
    
    private func configureInteractor() {
        Observable.merge(viewDidLoadRelay.asObservable(), refreshRelay.asObservable())
            .subscribe(onNext: { [weak self] in
                self?.view.isShowLoading.accept(true)
                self?.interactor.getSurveyList()
            }).disposed(by: disposeBag)
        
        swipeDirection.subscribe(onNext: { [weak self] direction in
            self?.handleSwipe(to: direction)
        }).disposed(by: disposeBag)
        
        detailButtonTapped.subscribe(onNext: { [weak self] in
            let currentIndex = self?.currentIndex.value
            let surveys = self?.surveys.value
            self?.router.routeToDetail(title: surveys?[currentIndex ?? 0].title ?? "")
        }).disposed(by: disposeBag)
    }
    
    private func handleSwipe(to direcion: UISwipeGestureRecognizer.Direction) {
        let currentIndex = currentIndex.value
        let count = surveys.value.count
        switch direcion {
        case .left:
            let nextIndex = (currentIndex + 1) < count ? currentIndex + 1 : 0
            self.currentIndex.accept(nextIndex)
        case .right:
            let nextIndex = (currentIndex - 1) >= 0 ? currentIndex - 1 : count - 1
            self.currentIndex.accept(nextIndex)
        default:
            return
        }
    }
}

// MARK: - SurveyListInteractableListener
extension SurveyListPresenter {
    func onGetListSurveySuccess(surveys: [Survey]) {
        view.isShowLoading.accept(false)
        self.surveys.accept(surveys)
    }
    
    func onGetListSurveyError(_ error: Error) {
        view.isShowLoading.accept(false)
    }
}
