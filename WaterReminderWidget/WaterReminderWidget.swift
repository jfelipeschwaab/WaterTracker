//
//  WaterReminderWidget.swift
//  WaterReminderWidget
//
//  Created by João Felipe Schwaab on 08/10/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), waterCount: 0)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, waterCount: 0)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let container = SharedPersistenceController.widgetContainer
        
        let modelContext = ModelContext(container)
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<Water> { water in
            water.date >= startOfDay && water.date < endOfDay
        }
        
        let fetchDescriptor = FetchDescriptor<Water>(predicate: predicate)

        do {
            let results = try modelContext.fetch(fetchDescriptor)
            guard let register = results.first else {
                let entry = SimpleEntry(date: Date(), configuration: configuration, waterCount: 0)
                return Timeline(entries: [entry], policy: .never)
            }

            let progress = (register.totalAmount / register.goalAmount) * 100
            let entry = SimpleEntry(date: Date(), configuration: configuration, waterCount: progress)
            return Timeline(entries: [entry], policy: .never)

        } catch {
            print("❌ Erro ao buscar dados: \(error)")
            let entry = SimpleEntry(date: Date(), configuration: configuration, waterCount: 0)
            return Timeline(entries: [entry], policy: .never)
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let waterCount: Double
}

struct WaterReminderWidgetEntryView: View {
    var entry: Provider.Entry

    // Progresso com base nos dados reais da Entry
    var progress: Double {
        min(entry.waterCount / 100.0, 1.0) // porque waterCount já é porcentagem
    }

    var percentageText: String {
        "\(Int(entry.waterCount))%"
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

                Button(intent: AddWaterIntent(amount: entry.configuration.$waterAmount)) {
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

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}
