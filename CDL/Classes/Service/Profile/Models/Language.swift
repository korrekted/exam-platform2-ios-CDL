//
//  Language.swift
//  CDL
//
//  Created by Andrey Chernyshev on 24.04.2021.
//

enum Language: Int {
    case spanish, english
}

// MARK: Codable
extension Language: Codable {}
