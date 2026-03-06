//
//  AquaShortcuts.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 13/10/25.
//

import Foundation
import AppIntents

struct AquaShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWaterIntent(),
            phrases: [
                "Adicionar água no \(.applicationName)",
                "Beber água no \(.applicationName)",
                "Adicionar \(\AddWaterIntent.$amount) no \(.applicationName)",
            ],
            shortTitle: "Adicionar Água",
            systemImageName: "drop.fill"
        )
        
        AppShortcut(
            intent: SetWaterGoalIntent(),
            phrases: [
                "Definir meta de água no \(.applicationName)",
                "Definir meta de \(\SetWaterGoalIntent.$goal) no \(.applicationName)",
                "Mudar meta de água para \(\SetWaterGoalIntent.$goal) no \(.applicationName)",
                "Hoje eu quero beber \(\SetWaterGoalIntent.$goal) de água! no \(.applicationName)"
            ],
            shortTitle: "Definir Meta de Água",
            systemImageName: "target"
        )
    }
}


enum WaterAmount: Int, AppEnum, CaseDisplayRepresentable {
    case m100 = 100
    case m200 = 200
    case m300 = 300
    case m400 = 400
    case m500 = 500

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Quantidade de água")
    
    static var caseDisplayRepresentations: [WaterAmount : DisplayRepresentation] {
        [
            .m100: "100 mL",
            .m200: "200 mL",
            .m300: "300 mL",
            .m400: "400 mL",
            .m500: "500 mL"
        ]
    }
}


