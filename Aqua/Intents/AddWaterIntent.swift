//
//  AddWaterIntent.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 10/10/25.
//

import Foundation
import SwiftData
import WidgetKit
import AppIntents


struct AddWaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Adicionar Água"

    @Parameter(title: "Quantidade de Água")
    var amount: WaterAmount

    func perform() async throws -> some IntentResult {
        let container = SharedPersistenceController.mainAppContainer
        let context = ModelContext(container)
        
        let fetch = FetchDescriptor<Water>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        if let register = try? context.fetch(fetch).first {
            register.totalAmount += Double(amount.rawValue)
            try? context.save()
        }

        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

