//
//  QuestionTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//
import UIKit
import RxSwift
import RxCocoa

final class QuestionTableView: UITableView {
    private lazy var elements = [TestingCellType]()
    let selectedAnswers = PublishRelay<[AnswerElement]>()
    let expandContent = PublishRelay<QuestionContentCollectionType>()
    
    private var selectedCells: Set<IndexPath> = [] {
        didSet {
            let answers = selectedCells
                .compactMap { indexPath -> AnswerElement? in
                    guard case let .answer(answer) = elements[safe: indexPath.row] else { return nil }
                    return answer
                }
            
            selectedAnswers.accept(answers)
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension QuestionTableView {
    func setup(question: QuestionElement) {
        elements = question.elements
        allowsMultipleSelection = question.isMultiple
        allowsSelection = !question.isResult
        selectedCells = []
        CATransaction.setCompletionBlock { [weak self] in
            let indexPath = IndexPath(row: question.isResult ? question.elements.count - 1 : 0, section: 0)
            self?.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        CATransaction.begin()
        reloadData()
        CATransaction.commit()
    }
}

// MARK: UITableViewDataSource
extension QuestionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableContentCell.self), for: indexPath) as! QuestionTableContentCell
            cell.configure(content: content) { [weak self] in
                self?.expandContent.accept($0)
            }
            return cell
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableQuestionCell.self), for: indexPath) as! QuestionTableQuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case let .answer(answer):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableAnswersCell.self), for: indexPath) as! QuestionTableAnswersCell
            return cell
        case let .explanation(explanation):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionTableExplanationTextCell.self), for: indexPath) as! QuestionTableExplanationTextCell
            cell.confugure(explanation: explanation, html: "")
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension QuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath) is QuestionTableAnswersCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? QuestionTableAnswersCell else { return }
        
        if selectedCells.contains(indexPath) {
            selectedCells.remove(indexPath)
            cell.setSelected(false, animated: false)
        } else {
            if allowsMultipleSelection {
                selectedCells.insert(indexPath)
            } else {
                selectedCells = [indexPath]
            }
            cell.setSelected(true, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is QuestionTableAnswersCell, selectedCells.contains(indexPath) {
            cell.setSelected(true, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .content:
            return 213.scale
        case .explanation, .question, .answer:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension QuestionTableView {
    func initialize() {
        register(QuestionTableContentCell.self, forCellReuseIdentifier: String(describing: QuestionTableContentCell.self))
        register(QuestionTableAnswersCell.self, forCellReuseIdentifier: String(describing: QuestionTableAnswersCell.self))
        register(QuestionTableQuestionCell.self, forCellReuseIdentifier: String(describing: QuestionTableQuestionCell.self))
        register(QuestionTableExplanationTextCell.self, forCellReuseIdentifier: String(describing: QuestionTableExplanationTextCell.self))
        separatorStyle = .none
        
        dataSource = self
        delegate = self
    }
}

