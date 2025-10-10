//
//  SharedPersistenceController.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 08/10/25.
//

import Foundation
import SwiftData

class SharedPersistenceController {
    
    private static let groupID = "group.com.jfelipeschwaab.com.Aqua"

    
    static var mainAppContainer : ModelContainer = {
        let schema = Schema([Water.self])
        
        let configuration = ModelConfiguration(schema: schema, groupContainer: .identifier(groupID), cloudKitDatabase: .automatic)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Erro ao criar o ModelContainer: \(error)")
        }
    }()
    
    static var widgetContainer: ModelContainer = {
        let schema = Schema([Water.self])
        
        let configuration = ModelConfiguration(schema: schema, allowsSave: false, groupContainer: .identifier(groupID))
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Erro ao criar o ModelContainer: \(error)")
        }
    }()
    
}
