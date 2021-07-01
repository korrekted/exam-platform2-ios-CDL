//
//  CorrectAnswersWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct CorrectAnswersWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CorrectAnswersWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.correctAnswers,
                                 title: "Stats.MainRate.CorrectAnswers".localized,
                                 color: Color(red: 249, green: 205, blue: 106))
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
