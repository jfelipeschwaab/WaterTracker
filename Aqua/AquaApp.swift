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
        let sharedContainer = SharedPersistenceController.mainAppContainer
        self.container = sharedContainer
        let context = ModelContext(self.container)
        let databaseController = DatabaseManager(context: context)
        _waterManager = StateObject(wrappedValue: WaterManager(dataController: databaseController, cloudKitController: .init()))
    }
    
    var body: some Scene {
        WindowGroup {
            Home(waterManager: waterManager)
        }
        .modelContainer(container)
    }
}
