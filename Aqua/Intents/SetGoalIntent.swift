//
//  SetGoalIntent.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 13/10/25.
//

import Foundation
import SwiftData
import WidgetKit
import AppIntents

struct SetWaterGoalIntent: AppIntent {
    static var title: LocalizedStringResource = "Definir Meta de Água"

    @Parameter(title: "Meta de Água")
    var goal: WaterGoal

    func perform() async throws -> some IntentResult {
        let container = SharedPersistenceController.mainAppContainer
        let context = ModelContext(container)
        
        let fetch = FetchDescriptor<Water>(sortBy: [SortDescriptor(\.date, order: .reverse)])

        if let register = try? context.fetch(fetch).first {
            register.goalAmount = Double(goal.rawValue)
            try? context.save()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}


enum WaterGoal: Int, AppEnum, CaseDisplayRepresentable {
    case g1000 = 1000
    case g1500 = 1500
    case g2000 = 2000
    case g2500 = 2500
    case g3000 = 3000

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Meta de água")
    
    static var caseDisplayRepresentations: [WaterGoal : DisplayRepresentation] {
        [
            .g1000: "1000 mL",
            .g1500: "1500 mL",
            .g2000: "2000 mL",
            .g2500: "2500 mL",
            .g3000: "3000 mL"
        ]
    }
}
