//
//  AquaApp.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//

import SwiftUI
import SwiftData

@main
struct AquaApp: App {
    let container : ModelContainer
    @StateObject var waterManager: WaterManager
    
    init() {
        do {
            container = try ModelContainer(for: Water.self)
            let context = ModelContext(container)
            let databaseController = DatabaseManager(context: context)
            
            _waterManager = StateObject(wrappedValue: WaterManager(dataController: databaseController))
        } catch {
            fatalError("Erro ao inicializar SwiftData: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Home(waterManager: waterManager)
        }
        .modelContainer(container)
    }
}
