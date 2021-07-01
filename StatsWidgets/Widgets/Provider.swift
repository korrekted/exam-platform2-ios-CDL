//
//  Provider.swift
//  StatsWidgetsExtension
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> StatsContent {
        return StatsContent.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (StatsContent) -> Void) {
        completion(StatsContent.placeholder)
    }

    func readContents() -> [Entry] {
        let stats = StatsContent(passRate: 0.5,
                                 testTaken: 0.5,
                                 correctAnswers: 0.5,
                                 questionsTaken: 0.1)
        return [stats]
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StatsContent>) -> Void) {
        let entries = readContents()
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
