//
//  SpecificTopic.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

struct SpecificTopic {
    let id: Int
    let title: String
    let description: String
    let isMain: Bool
}

// MARK: Codable
extension SpecificTopic: Codable {}

// MARK: Hashable
extension SpecificTopic: Hashable {}
