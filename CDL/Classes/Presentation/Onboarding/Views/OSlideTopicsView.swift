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
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var topicsView = makeTopicsCollectionView()
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var tryAgainTrigger = PublishRelay<Void>()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        topicsCollectionViewDidChangeSelection()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        tryAgainTrigger
            .startWith(Void())
            .flatMapLatest { [weak self] _ -> Observable<[TopicsCollectionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                return Single
                    .zip(
                        self.manager.obtainSpecificTopics(),
                        self.manager.obtainSelectedSpecificTopics()
                    ) { topics, selectedTopics -> [TopicsCollectionElement] in
                        topics.map { topic -> TopicsCollectionElement in
                            TopicsCollectionElement(topic: topic, isSelected: selectedTopics.contains(topic))
                        }
                    }
                    .catchAndReturn([])
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] elements in
                guard let self = self else {
                    return
                }
                
                if elements.isEmpty {
                    self.openError()
                } else {
                    self.topicsView.setup(elements: elements)
                    self.topicsCollectionViewDidChangeSelection()
                }
            })
            .disposed(by: disposeBag)
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
        button.rx.tap
            .map { [weak self] _ -> [SpecificTopic] in
                guard let self = self else {
                    return []
                }
                
                return self.topicsView.elements
                    .filter { $0.isSelected }
                    .map { $0.topic }
            }
            .flatMapLatest { [weak self] topics -> Single<[SpecificTopic]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.manager
                    .saveSelected(specificTopics: topics)
                    .map { topics }
            }
            .subscribe(onNext: { [weak self] topics in
                guard let self = self else {
                    return
                }
                
                self.scope.topicsIds = topics.map { $0.id }
                
                self.onNext()
            })
            .disposed(by: disposeBag)
        
        activity
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                activity ? self.preloader.startAnimating() : self.preloader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.tryAgainTrigger.accept(Void())
        }
        vc?.present(tryAgainVC, animated: true)
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
            topicsView.heightAnchor.constraint(equalToConstant: 392.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            button.heightAnchor.constraint(equalToConstant: 53.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideTopicsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Onboarding.primaryText)
            .font(Fonts.Lato.bold(size: 36.scale))
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
            .font(Fonts.Lato.regular(size: 18.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Onboarding.primaryButton
        view.layer.cornerRadius = 12.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 60.scale, height: 60.scale), color: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
