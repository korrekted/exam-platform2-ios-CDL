//
//  TestCoordinator.swift
//  CDL
//
//  Created by Андрей Чернышев on 21.06.2022.
//

import UIKit

final class TestCoordinator {
    static let shared = TestCoordinator()
    
    private var testVC: TestViewController?
    private var testStatsVC: TestStatsViewController?
    
    private weak var from: UIViewController?
    
    private init() {}
}

// MARK: Public
extension TestCoordinator {
    func start(testTypes: [TestType], course: Course, from: UIViewController?) {
        self.from = from
        
        openTest(with: course, testType: testTypes.first!)
    }
}

// MARK: TestViewControllerDelegate
extension TestCoordinator: TestViewControllerDelegate {
    func testViewControllerDismiss() {
        testVC?.dismiss(animated: true)
        testVC = nil
    }
    
    func testViewControllerClose(finish: TestFinishElement) {
//        testVC?.dismiss(animated: true) {
//            TestCloseMediator.shared.notifyAboudTestClosed(with: finish)
//        }
//        testVC = nil
    }
    
    func testViewControllerNeedPayment() {
        testVC?.dismiss(animated: true) {
            let rootVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            rootVC?.present(PaygateViewController.make(), animated: true)
        }
        testVC = nil
    }
    
    func testViewController(finish: TestFinishElement) {
//        testStatsVC = TestStatsViewController.make(finish: finish)
//        testStatsVC?.delegate = self
//
//        testVC?.dismiss(animated: true) {
//            Self.shared.from?.present(Self.shared.testStatsVC!, animated: true)
//        }
    }
}

// MARK: Private
private extension TestCoordinator {
    func openTest(with course: Course, testType: TestType) {
        testVC = TestViewController.make(course: course, testType: testType)
        testVC?.delegate = self
        from?.present(testVC!, animated: true)
    }
}
