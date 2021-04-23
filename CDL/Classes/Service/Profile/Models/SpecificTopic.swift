//
//  SpecificTopic.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

struct SpecificTopic {
    let id: Int
    let title: String
}

// MARK: Codable
extension SpecificTopic: Codable {}

// MARK: Hashable
extension SpecificTopic: Hashable {}
