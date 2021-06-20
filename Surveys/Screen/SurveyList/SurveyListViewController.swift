//
//  SurveyListViewController.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/19/21.
//

import UIKit
import SkeletonView
import Kingfisher

protocol SurveyListViewable: Viewable {
    var presenter: SurveyListPresentable! { get set }
    var isShowLoading: BehaviorRelay<Bool> { get }
    var viewModel: BehaviorRelay<SurveyViewModel?> { get }
}

final class SurveyListViewController: UIViewController, SurveyListViewable {
    
    var presenter: SurveyListPresentable!

    let isShowLoading = BehaviorRelay<Bool>(value: false)
    let viewModel = BehaviorRelay<SurveyViewModel?>(value: nil)
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var todayLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    private lazy var swipeRightGesture: UISwipeGestureRecognizer = {
        let gesture = makeSwipeGesture(.right)
        return gesture
    }()
    private lazy var swipeLeftGesture: UISwipeGestureRecognizer = {
        let gesture = makeSwipeGesture(.left)
        return gesture
    }()
    private lazy var swipeDownGesture: UISwipeGestureRecognizer = {
        let gesture = makeSwipeGesture(.down)
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            presenter.viewDidLoadRelay.accept(())
        }
        configureView()
        configurePresenter()
        configureViewable()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func configureView() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        SkeletonAppearance.default.multilineCornerRadius = 8

        view.backgroundColor = .darkText
        
        dateLabel.font = UIFont(name: FontName.neuzeitBookStandard, size: 13)
        dateLabel.textColor = .white
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MM"
        dateLabel.text = dateFormatter.string(from: Date())
        
        todayLabel.font = UIFont(name: FontName.neuzeitBookHeavy, size: 34)
        todayLabel.textColor = .white
        
        titleLabel.font = UIFont(name: FontName.neuzeitBookHeavy, size: 28)
        titleLabel.textColor = .white
        
        descriptionLabel.font = UIFont(name: FontName.neuzeitBookRegular, size: 17)
        descriptionLabel.textColor = .gray
        
        detailButton.layer.cornerRadius = detailButton.frame.height / 2
        detailButton.setImage(Images.arrowRight, for: .normal)
        detailButton.backgroundColor = .white
        
        coverImageView.kf.indicatorType = .activity
        
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    private func configurePresenter() {
        detailButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.presenter.detailButtonTapped.accept(())
        }).disposed(by: disposeBag)
    }
    
    private func configureViewable() {
        isShowLoading.asDriver()
            .drive(onNext: { [weak self] isShowing in
                if isShowing {
                    let gradient = SkeletonGradient(baseColor: .darkGray)
                    self?.view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.3))
                } else { self?.view.hideSkeleton() }
            }).disposed(by: disposeBag)
        
        viewModel.asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] model in
                self?.titleLabel.text = model.title
                self?.descriptionLabel.text = model.descipton
                self?.pageControl.currentPage = model.currentPage
                self?.pageControl.numberOfPages = model.numberPage
                if let url = URL(string: model.image) {
                    self?.coverImageView.kf.setImage(with: url)
                }
            }).disposed(by: disposeBag)
    }
    
    private func makeSwipeGesture(_ direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGesture.direction = direction
        return swipeGesture
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right, .left:
            presenter.swipeDirection.accept(gesture.direction)
        case .down:
            presenter.refreshRelay.accept(())
        default:
            return
        }
    }
}
