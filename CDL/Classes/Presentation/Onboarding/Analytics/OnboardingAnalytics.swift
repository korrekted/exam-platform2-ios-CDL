//
//  OnboardingAnalytics.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.02.2021.
//

final class OnboardingAnalytics {
    func log(step: OnboardingView.Step) {
        let name: String
        
        switch step {
        case .welcome:
            name = "Welcome Screen"
        case .topics:
            name = "Topics Screen"
        case .locale:
            name = "Locale Screen"
        case .goals:
            name = "Goals Screen"
        case .mode:
            name = "Mode Screen"
        case .whenTaking:
            name = "When Exam Screen"
        case .minutesAtTime:
            name = "Minutes At Time Screen"
        case .time:
            name = "Test Time Screen"
        case .count:
            name = "Tests Number Screen"
        case .experience:
            name = "Experience Screen"
        case .whenStudy:
            name = "When Study Screen"
        case .preloader:
            name = "Plan Preparing Screen"
        case .plan:
            name = "Personal Plan Screen"
        case .push:
            name = "Push Screen"
        }
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: [:])
    }
}
