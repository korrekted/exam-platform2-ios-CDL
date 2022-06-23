//
//  Answer.swift
//  CDL
//
//  Created by Андрей Чернышев on 23.06.2022.
//

struct Answer: Codable, Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let isCorrect: Bool
}
