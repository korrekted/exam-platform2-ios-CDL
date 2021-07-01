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
                                 color: Color(red: 41 / 255, green: 55 / 255, blue: 137 / 255))
                Spacer()
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 249 / 255, green: 205 / 255, blue: 106 / 255))
                Spacer()
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 196 / 255, green: 42 / 255, blue: 80 / 255))
            }
            .padding(16)
        }
        .supportedFamilies([.systemMedium])
    }
}
