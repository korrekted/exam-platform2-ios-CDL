//
//  QuestionTableElement.swift
//  CDL
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import Foundation

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

enum TestingCellType {
    case content([QuestionContentCollectionType])
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

struct PossibleAnswerElement: Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
}

struct AnswerResultElement {
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let state: AnswerState
}

enum AnswerState {
    case initial, correct, warning, error
}
