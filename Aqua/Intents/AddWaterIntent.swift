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
    static var description = IntentDescription("Adiciona uma quantidade específica de água ao registro atual.")
    
    @Parameter(title: "Quantidade (mL)", default: 200)
    var amount: Int
    
    func perform() async throws -> some IntentResult {
        print("💧 Executando AddWaterIntent com \(amount)mL")

        let container = SharedPersistenceController.mainAppContainer
        let context = ModelContext(container)
        
        let fetch = FetchDescriptor<Water>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        if let register = try? context.fetch(fetch).first {
            register.totalAmount += Double(amount)
            try? context.save()
            print("💾 Novo total: \(register.totalAmount) / \(register.goalAmount)")
        } else {
            print("⚠️ Nenhum registro encontrado.")
        }
        
        
        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}
