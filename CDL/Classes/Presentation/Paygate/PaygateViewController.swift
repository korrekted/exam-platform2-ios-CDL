//
//  PaygateViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 08.07.2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PaygateViewController: UIViewController {
    lazy var paygateView = PaygateView()
    
    weak var delegate: PaygateViewControllerDelegate?
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    override func loadView() {
        super.loadView()
        
        view = paygateView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Paygate Screen", parameters: [:])
        
        addMainOptionsSelection()
        
        viewModel.monetizationConfig()
            .drive(onNext: { [weak self] config in
                self?.retrieve(config: config)
            })
            .disposed(by: disposeBag)
        
        let retrieved = viewModel.retrieve()
        
        retrieved
            .drive(onNext: { [weak self] paygate, completed in
                guard let `self` = self, let paygate = paygate else {
                    return
                }
                
                if let main = paygate.main {
                    self.paygateView.mainView.setup(paygate: main)
                }
            })
            .disposed(by: disposeBag)
        
        let paygate = retrieved
            .map { $0.0 }
            .startWith(nil)
        
        paygateView
            .mainView
            .closeButton.rx.tap
            .withLatestFrom(paygate)
            .subscribe(onNext: { [unowned self] paygate in
                self.dismiss(with: .cancelled)
            })
            .disposed(by: disposeBag)
        
        paygateView
            .mainView
            .continueButton.rx.tap
            .subscribe(onNext: { [unowned self] productId in
                guard let productId = [self.paygateView.mainView.leftOptionView, self.paygateView.mainView.rightOptionView]
                    .first(where: { $0.isSelected })?
                    .productId
                else {
                    return
                }
                
                self.viewModel.buy.accept(productId)
            })
            .disposed(by: disposeBag)
        
        paygateView
            .mainView
            .restoreButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                guard let productId = [self.paygateView.mainView.leftOptionView, self.paygateView.mainView.rightOptionView]
                    .first(where: { $0.isSelected })?
                    .productId
                else {
                    return
                }
                
                self.viewModel.restore.accept(productId)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(viewModel.buyProcessing.asDriver(),
                   viewModel.restoreProcessing.asDriver(),
                   viewModel.retrieveCompleted.asDriver(onErrorJustReturn: true).map { !$0 })
            .drive(onNext: { [weak self] isLoading in
                self?.paygateView.mainView.continueButton.isHidden = isLoading
                self?.paygateView.mainView.restoreButton.isHidden = isLoading

                isLoading ? self?.paygateView.mainView.purchasePreloaderView.startAnimating() : self?.paygateView.mainView.purchasePreloaderView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .buyed
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Purchase.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .bied)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .restored
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Purchase.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .restored)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func retrieve(config: PaygateViewModel.Config) {
        switch config {
        case .block:
            paygateView.mainView.closeButton.isHidden = true
        case .suggest:
            paygateView.mainView.closeButton.isHidden = false
        }
    }
    
    func addMainOptionsSelection() {
        let leftOptionTapGesture = UITapGestureRecognizer()
        paygateView.mainView.leftOptionView.addGestureRecognizer(leftOptionTapGesture)
        
        leftOptionTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = self.paygateView.mainView.leftOptionView.productId {
                    self.viewModel.buy.accept(productId)
                }
                
                guard !self.paygateView.mainView.leftOptionView.isSelected else {
                    return
                }
                
                self.paygateView.mainView.leftOptionView.isSelected = true
                self.paygateView.mainView.rightOptionView.isSelected = false
            })
            .disposed(by: disposeBag)
        
        let rightOptionTapGesture = UITapGestureRecognizer()
        paygateView.mainView.rightOptionView.addGestureRecognizer(rightOptionTapGesture)
        
        rightOptionTapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                if let productId = self.paygateView.mainView.rightOptionView.productId {
                    self.viewModel.buy.accept(productId)
                }
                
                guard !self.paygateView.mainView.rightOptionView.isSelected else {
                    return
                }
                
                self.paygateView.mainView.leftOptionView.isSelected = false
                self.paygateView.mainView.rightOptionView.isSelected = true
            })
            .disposed(by: disposeBag)
    }
    
    func dismiss(with result: PaygateViewControllerResult) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.paygateDidClosed(with: result)
        }
    }
}
