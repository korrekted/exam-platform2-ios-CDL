//
//  TestTakenWidget.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit
import SwiftUI

struct TestTakenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TestTakenWidget", provider: Provider()) { entry in
            HStack {
                VerticalRateView(progress: entry.testTaken,
                                 title: "Stats.MainRate.TestsTake".localized,
                                 color: Color(red: 41, green: 55, blue: 137))
                Spacer()
            }
            .padding(16.scale)
        }
        .supportedFamilies([.systemSmall])
    }
}
