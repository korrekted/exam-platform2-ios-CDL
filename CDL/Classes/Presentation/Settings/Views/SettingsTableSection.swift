//
//  SettingsTableSection.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

enum SettingsTableSection {
    enum Change {
        case topics, locale
    }
    
    case unlockPremium
    case links
    case settings([Change])
}
