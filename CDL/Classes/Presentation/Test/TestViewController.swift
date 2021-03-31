//
//  TestViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit

final class TestViewController: UIViewController {
    lazy var mainView = TestView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((Int) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        
        let courseName = viewModel.courseName
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .withLatestFrom(courseName) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (answers, name) = stub
                
                self?.viewModel.answers.accept(answers)
                self?.logTapAnalytics(courseName: name, what: "answer")
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomButton.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .submit ? () : nil }
            .bind(to: viewModel.didTapSubmit)
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.viewModel.didTapNext.accept(Void())
                self?.logTapAnalytics(courseName: name, what: "continue")
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .map { $0.questionsCount == 1 }
            .distinctUntilChanged()
            .drive(Binder(mainView) {
                $0.needAddingCounter(isOne: $1)
            })
            .disposed(by: disposeBag)
        
        viewModel.rightCounterValue
            .drive(Binder(mainView) { base, element in
                base.counter.setRightContent(value: element.value, isError: element.isError)
            })
            .disposed(by: disposeBag)
        
        viewModel.leftCounterValue
            .drive(Binder(mainView) { base, element in
                base.counter.setLeftContent(value: element)
            })
            .disposed(by: disposeBag)
        
        let isHiddenNext = Driver
            .merge(
                viewModel.isEndOfTest,
                mainView.nextButton.rx.tap.asDriver().map { _ in true }
            )
        
        isHiddenNext
            .drive(mainView.nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        let nextOffset = isHiddenNext
            .map { [weak mainView] isHidden -> CGFloat in
                let bottomOffset = mainView.map { $0.bounds.height - $0.nextButton.frame.minY + 9.scale } ?? 0
                return isHidden ? 0 : bottomOffset
            }
        
        let bottomButtonOffset = viewModel.bottomViewState.map { $0 == .hidden ? 0 : 195.scale }
        
        Driver
            .merge(nextOffset, bottomButtonOffset)
            .distinctUntilChanged()
            .drive(Binder(mainView.tableView) {
                $0.contentInset = UIEdgeInsets(top: $0.contentInset.top, left: 0, bottom: $1, right: 0)
            })
            .disposed(by: disposeBag)
        
        viewModel.userTestId
            .withLatestFrom(courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, stub in
                let (id, name) = stub
                
                base.didTapSubmit?(id)
                base.logTapAnalytics(courseName: name, what: "finish test")
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .drive(Binder(mainView) {
                $0.setupBottomButton(for: $1)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .bind(to: Binder(self) { base, content in
                switch content {
                case let .image(url):
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    do {
                        try imageView.image = UIImage(data: Data(contentsOf: url))
                        let controller = UIViewController()
                        controller.view.backgroundColor = .black
                        controller.view.addSubview(imageView)
                        imageView.frame = controller.view.bounds
                        base.present(controller, animated: true)
                    } catch {
                        
                    }
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit { [weak self] message in
                Toast.notify(with: message, style: .danger)
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.needPayment
            .filter { $0 }
            .emit { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
                })
            }
            .disposed(by: disposeBag)
            
        viewModel.needPayment
            .filter(!)
            .withLatestFrom(courseName)
            .emit(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .withLatestFrom(courseName)
            .subscribe(onNext: { [weak self] name in
                self?.logTapAnalytics(courseName: name, what: "media")
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { [.submit, .back].contains($0) }
            .withLatestFrom(viewModel.needPayment)
            .subscribe(onNext: { needPayment in
                guard !needPayment else { return }
                RateManagerCore().showFirstAfterPassRateAlert()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType, activeSubscription: Bool, courseId: Int) -> TestViewController {
        let controller = TestViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.activeSubscription = true
        controller.viewModel.testType.accept(testType)
        controller.viewModel.courseId.accept(courseId)
        controller.mainView.navigationView.setTitle(title: testType.name)
        let leftCounterTitle: String
        let rightCounterTitle: String
        switch testType {
        case .timedQuizz:
            leftCounterTitle = "Question.Counter.Question".localized
            rightCounterTitle = "Question.Counter.RemainingTime".localized
        default:
            leftCounterTitle = "Question.Counter.Score".localized
            rightCounterTitle = "Question.Counter.Question".localized
        }
        
        controller.mainView.counter.setup(leftTitle: leftCounterTitle, rightTitle: rightCounterTitle)
        return controller
    }
}

// MARK: Private
private extension TestViewController {
    func logAnalytics(courseName: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Screen", parameters: ["course": courseName,
                                                            "mode": name])
    }
    
    func logTapAnalytics(courseName: String, what: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Question Tap", parameters: ["course": courseName,
                                                         "mode": name,
                                                         "what": what])
    }
    
    @objc func popAction() {
        navigationController?.popViewController(animated: true)
    }
}
