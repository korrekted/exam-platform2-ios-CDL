//
//  MediumRateWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct MediumRateWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MediumRateWidget", provider: Provider()) { entry in
            HStack(alignment: .center) {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: Color(red: 41, green: 55, blue: 137))
                Spacer()
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 249, green: 205, blue: 106))
                Spacer()
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 196, green: 42, blue: 80))
            }
            .padding(16)
        }
        .supportedFamilies([.systemMedium])
    }
}
