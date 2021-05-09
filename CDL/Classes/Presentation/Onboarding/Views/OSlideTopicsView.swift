//
//  OSlideTopicsView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 16.04.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideTopicsView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var topicsView = makeTopicsCollectionView()
    lazy var button = makeButton()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        topicsCollectionViewDidChangeSelection()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: TopicsCollectionViewDelegate
extension OSlideTopicsView: TopicsCollectionViewDelegate {
    func topicsCollectionViewDidChangeSelection() {
        changeEnabled()
    }
}

// MARK: Private
private extension OSlideTopicsView {
    func initialize() {
        Single
            .zip(
                manager.obtainSpecificTopics(),
                manager.obtainSelectedSpecificTopics()
            ) { topics, selectedTopics -> [TopicsCollectionElement] in
                topics.map { topic -> TopicsCollectionElement in
                    TopicsCollectionElement(topic: topic, isSelected: selectedTopics.contains(topic))
                }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] elements in
                self?.topicsView.setup(elements: elements)
                self?.topicsCollectionViewDidChangeSelection()
            })
            .disposed(by: disposeBag)
        
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let selectedTopics = self.topicsView.elements
                    .filter { $0.isSelected }
                    .map { $0.topic }
                
                return self.manager
                    .set(topicsIds: selectedTopics.map { $0.id })
                    .flatMap {
                        self.manager.saveSelected(specificTopics: selectedTopics)
                    }
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    func changeEnabled() {
        let isEmpty = topicsView.elements
            .filter { $0.isSelected }
            .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideTopicsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: topicsView.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            topicsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topicsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topicsView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -48.scale),
            topicsView.heightAnchor.constraint(equalToConstant: 335.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 53.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideTopicsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.SFProRounded.bold(size: 36.scale))
            .lineHeight(43.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlideTopics.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTopicsCollectionView() -> TopicsCollectionView {
        let view = TopicsCollectionView(frame: .zero, collectionViewLayout: TopicsCollectionLayout())
        view.topicsCollectionViewDelegate = self
        view.contentInset = UIEdgeInsets(top: 0, left: 16.scale, bottom: 0, right: 16.scale)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryButtonTint)
            .font(Fonts.SFProRounded.semiBold(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
