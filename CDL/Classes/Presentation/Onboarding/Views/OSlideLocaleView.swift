//
//  OSlideLocaleView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 25.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideLocaleView: OSlideView {
    lazy var scrollView = makeScrollView()
    lazy var countryView = LocaleCountryView()
    lazy var languageView = LocaleLanguageView()
    lazy var stateView = LocaleStateView()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentViews: [UIView] = {
        [
            countryView,
            languageView,
            stateView
        ]
    }()
}

// MARK: Private
private extension OSlideLocaleView {
    func initialize() {
        backgroundColor = Onboarding.background
        
        countryView.onNext = { [weak self] in
            self?.countrySelected()
        }
        
        languageView.onNext = { [weak self] in
            self?.languageSelected()
        }
        
        stateView.onNext = { [weak self] in
            self?.stateSelected()
        }
        
        contentViews
            .enumerated()
            .forEach { index, view in
                scrollView.addSubview(view)
                
                view.frame.origin = CGPoint(x: UIScreen.main.bounds.width * CGFloat(index), y: 0)
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
            }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(contentViews.count),
                                        height: UIScreen.main.bounds.height)
    }
    
    func countrySelected() {
        scroll(to: languageView)
    }
    
    func languageSelected() {
        scroll(to: stateView)
    }
    
    func stateSelected() {
        onNext()
    }
    
    func scroll(to view: UIView) {
        let frame = view.frame
        
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// MARK: Make constraints
private extension OSlideLocaleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideLocaleView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
