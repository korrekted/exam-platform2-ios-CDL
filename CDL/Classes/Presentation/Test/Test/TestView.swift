//
//  TestView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit

final class TestView: UIView {
    lazy var navigationView = makeNavigationView()
    lazy var counter = makeCounterView()
    lazy var tableView = makeTableView()
    lazy var bottomView = makeBottomView()
    lazy var preloader = makePreloader()
    
    private var navigationHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
extension TestView {
    func needAddingCounter(isOne: Bool) {
        if !isOne {
            addSubview(counter)
            NSLayoutConstraint.activate([
                counter.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
                counter.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 36)
            ])
            
            tableView.contentInset.top = 35.scale
            
            navigationHeightConstraint?.constant = 167.scale
            navigationView.setNeedsDisplay()
        }
    }
    
    func saveQuestion(_ isSave: Bool) {
        let image = isSave ? UIImage(named: "Question.Bookmark.Check") : UIImage(named: "Question.Bookmark.Uncheck")
        navigationView.rightAction.setImage(image, for: .normal)
    }
}

// MARK: Private
private extension TestView {
    func initialize() {
        backgroundColor = TestPalette.background
    }
}

// MARK: Make constraints
private extension TestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: topAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        ])
        
        navigationHeightConstraint = navigationView.heightAnchor.constraint(equalToConstant: 125.scale)
        navigationHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 177.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestView {
    func makeNavigationView() -> NavigationBar {
        let view = NavigationBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = NavigationPalette.navigationBackground
        view.leftAction.setImage(UIImage(named: "General.Pop"), for: .normal)
        view.leftAction.tintColor = NavigationPalette.navigationTint
        view.rightAction.tintColor = NavigationPalette.navigationTint
        addSubview(view)
        return view
    }
    
    func makeCounterView() -> TestProgressView {
        let view = TestProgressView()
        view.backgroundColor = ScorePalette.background
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> TestBottomView {
        let view = TestBottomView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 60.scale, height: 60.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
