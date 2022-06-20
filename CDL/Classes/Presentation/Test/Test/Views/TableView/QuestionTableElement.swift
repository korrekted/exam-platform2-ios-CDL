//
//  QuestionTableElement.swift
//  CDL
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import Foundation

enum TestingCellType {
    case content([QuestionContentType])
    case question(String, html: String)
    case answer(AnswerElement)
    case explanation(String)
}

struct AnswerElement {
    let id: Int
    let answer: String
    let image: URL?
    var state: AnswerState
    let isCorrect: Bool
}

enum AnswerState {
    case initial, correct, warning, error
}

struct QuestionElement {
    let id: Int
    let elements: [TestingCellType]
    let isMultiple: Bool
    let index: Int
    let isAnswered: Bool
    let questionsCount: Int
    let explanation: String?
    let isResult: Bool
}
