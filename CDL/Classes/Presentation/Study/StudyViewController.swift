//
//  StudyViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StudyViewController: UIViewController {
    lazy var mainView = StudyView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StudyViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activeSubscription = viewModel.activeSubscription
        
        viewModel
            .course
            .map { $0.name }
            .drive(onNext: { name in
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Screen", parameters: ["exam": name])
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.collectionView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        viewModel.activeSubscription
            .drive(Binder(mainView) {
                $0.setupButtons($1)
            })
            .disposed(by: disposeBag)
        
        mainView
            .navigationView.rightAction.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.settingsTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.brief
            .drive(Binder(mainView) {
                $0.setup(brief: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.takeButton.rx.tap
            .withLatestFrom(viewModel.activeSubscription)
            .withLatestFrom(viewModel.course) { ($0, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (activeSubscription, course) = tuple
                base.openTest(types: [.get(testId: nil)], activeSubscription: activeSubscription, courseId: course.id)
                
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Tap", parameters: ["what": "take a free test"])
            })
            .disposed(by: disposeBag)
        
        mainView.unlockButton.rx.tap
            .bind(to: Binder(self) { base, _ in
                base.openPaygate()
                
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Tap", parameters: ["what": "unlock all questions"])
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedMode
            .withLatestFrom(activeSubscription) { ($0, $1) }
            .withLatestFrom(viewModel.course) { ($0.0, $0.1, $1) }
            .bind(to: Binder(self) { base, tuple in
                let (mode, activeSubscription, course) = tuple
                base.tapped(mode: mode, activeSubscription: activeSubscription, courseId: course.id)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.didTapTrophy
            .asSignal()
            .emit(onNext: {
                UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView
            .selectedCourse
            .bind(to: viewModel.selectedCourse)
            .disposed(by: disposeBag)
        
    }
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController.make(), animated: true)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Study Tap", parameters: ["what": "settings"])
    }
    
    func tapped(mode: SCEMode.Mode, activeSubscription: Bool, courseId: Int) {
        switch mode {
        case .ten:
            openTest(types: [.tenSet], activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "10 questions"])
        case .random:
            openTest(types: [.randomSet], activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "random set"])
        case .missed:
            openTest(types: [.failedSet], activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "missed questions"])
        case .today:
            openTest(types: [.qotd], activeSubscription: activeSubscription, courseId: courseId)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "question of the day"])
        }
    }
    
    func openTest(types: [TestType], activeSubscription: Bool, courseId: Int) {
        let controller = TestViewController.make(testTypes: types, activeSubscription: activeSubscription, courseId: courseId)
        controller.didTapSubmit = { [weak self, weak controller] element in
            let testStatsController = TestStatsViewController.make(element: element)
            testStatsController.didTapNext = controller?.loadNext
            testStatsController.didTapTryAgain = controller?.tryAgain
            self?.present(testStatsController, animated: true)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openPaygate() {
        UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
    }
}
