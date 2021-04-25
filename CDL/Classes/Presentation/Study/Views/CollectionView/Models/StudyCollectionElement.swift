//
//  StudyCollectionElement.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 30.01.2021.
//

struct StudyCollectionSection {
    let elements: [StudyCollectionElement]
}

enum StudyCollectionElement {
    case courses([CourseElement])
    case trophy
    case title(String)
    case mode(activeSubscription: Bool)
}

struct SCEBrief {
    struct Day {
        let date: Date
        let activity: Bool
    }
    
    let courseName: String
    let streakDays: Int
    let calendar: [Day]
}

struct SCEMode {
    enum Mode {
        case today
        case ten
        case missed
        case random
        case time
    }
}
