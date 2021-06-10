//
//  FlashcardsViewController.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit
import RxSwift

final class FlashcardsViewController: UIViewController {
    lazy var mainView = FlashcardsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = FlashcardsViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navigationView.leftAction.addTarget(self, action: #selector(popAction), for: .touchUpInside)
    }
}

// MARK: Make
extension FlashcardsViewController {
    static func make(topic: FlashcardTopic) -> FlashcardsViewController {
        let vc = FlashcardsViewController()
        vc.viewModel.flashcardTopicId.accept(topic.id)
        vc.mainView.navigationView.setTitle(title: topic.name)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension FlashcardsViewController {
    @objc
    func popAction() {
        navigationController?.popViewController(animated: true)
    }
}

