//
//  WaterReminderWidget.swift
//  WaterReminderWidget
//
//  Created by João Felipe Schwaab on 08/10/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

import SwiftUI
import WidgetKit

import SwiftUI
import WidgetKit

struct WaterReminderWidgetEntryView: View {
    var entry: Provider.Entry
    
    // Dados mockados
    let currentAmount: Int = 1200
    let totalGoal: Int = 2000
    
    var progress: Double {
        return min(Double(currentAmount) / Double(totalGoal), 1.0)
    }
    
    // Calcula porcentagem
    var percentageText: String {
        return "\(Int(progress * 100))%"
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Círculo de progresso
                ZStack {
                    Circle()
                        .stroke(lineWidth: 12)
                        .opacity(0.2)
                        .foregroundColor(.white)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: progress)
                    
                    // Porcentagem no centro
                    Text(percentageText)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(width: 60, height: 60)
                
                Button(action: {
                    print("Adicionar água pressionado")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Image(systemName: "drop.fill")
                    }
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }
}


struct WaterReminderWidget: Widget {
    let kind: String = "WaterReminderWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterReminderWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    WaterReminderWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
