//
//  FlashcardsTableView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 10.06.2021.
//

import UIKit

final class FlashcardsTableView: UITableView {
    private lazy var flashcards = [FlashcardTopic]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension FlashcardsTableView {
    func setup(flashcards: [FlashcardTopic]) {
        self.flashcards = flashcards
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension FlashcardsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        flashcards.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: FlashcardsTableCell.self)) as! FlashcardsTableCell
        cell.setup(flashcard: flashcards[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension FlashcardsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }
}

// MARK: Private
private extension FlashcardsTableView {
    func initialize() {
        register(FlashcardsTableCell.self, forCellReuseIdentifier: String(describing: FlashcardsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
