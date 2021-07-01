//
//  PassRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct PassRateWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PassRateWidget", provider: Provider()) { entry in
            VStack {
                PassRateView(title: "Stats.PassRate.Title".localized,
                             progress: entry.passRate)
                Spacer()
                HorizontalRateView(progress: entry.testTaken,
                                   title: "Stats.MainRate.TestsTake".localized,
                                   color: Color(red: 41, green: 55, blue: 137))
                Spacer()
                HorizontalRateView(progress: entry.correctAnswers,
                                   title: "Stats.MainRate.CorrectAnswers".localized,
                                   color: Color(red: 249, green: 205, blue: 106))
                Spacer()
                HorizontalRateView(progress: entry.questionsTaken,
                                   title: "Stats.MainRate.QuestionsTaken".localized,
                                   color: Color(red: 196, green: 42, blue: 80))
            }
            .padding(16)
        }
        .supportedFamilies([.systemLarge])
    }
}

