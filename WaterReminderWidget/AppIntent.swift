//
//  AppIntent.swift
//  WaterReminderWidget
//
//  Created by João Felipe Schwaab on 08/10/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configurar Widget" }
    static var description: IntentDescription { "Escolha quanto de água adicionar por toque" }

    // An example configurable parameter.
    @Parameter(
        title: "Quantidade de Água (mL)",
        default: 200
    )
    var waterAmount: Int
}
