//
//  QuestionsTakenWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct QuestionsTakenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "QuestionsTakenWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.questionsTaken,
                                 title: "Stats.MainRate.QuestionsTaken".localized,
                                 color: Color(red: 196 / 255, green: 42 / 255, blue: 80 / 255),
                                 alignment: .leading)
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
