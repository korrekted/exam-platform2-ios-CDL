//
//  SSlideTopicsView.swift
//  CDL
//
//  Created by Андрей Чернышев on 17.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class SSlideTopicsView: SSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var topicsView = makeTopicsCollectionView()
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    private lazy var coursesManager = CoursesManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        topicsCollectionViewDidChangeSelection()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        func source() -> Single<[TopicsCollectionElement]> {
            coursesManager
                .obtainCourses()
                .map { courses -> [TopicsCollectionElement] in
                    courses.map { course -> TopicsCollectionElement in
                        TopicsCollectionElement(course: course, isSelected: course.selected)
                    }
                }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            openError()
        }
        
        observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .subscribe(onNext: { [weak self] elements in
                self?.topicsView.setup(elements: elements)
                self?.topicsCollectionViewDidChangeSelection()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: TopicsCollectionViewDelegate
extension SSlideTopicsView: TopicsCollectionViewDelegate {
    func topicsCollectionViewDidChangeSelection() {
        changeEnabled()
    }
}

// MARK: Private
private extension SSlideTopicsView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                let selectedCoursesIds = self.topicsView.elements
                    .filter { $0.isSelected }
                    .map { $0.course.id }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(selectedCoursesIds: selectedCoursesIds)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    self.openError()
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] in
                self?.onNext()
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
    
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
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
private extension SSlideTopicsView {
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
private extension SSlideTopicsView {
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
