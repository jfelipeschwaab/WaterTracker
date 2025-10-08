//
//  GoalEditView.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 08/10/25.
//
import Foundation
import SwiftUI

struct GoalEditView: View {
    @ObservedObject var waterManager: WaterManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Defina sua meta diária")
                    .font(.title2.bold())

                Stepper(value: Binding(
                    get: { waterManager.registerOfTheDay?.goalAmount ?? 2000 },
                    set: { newValue in waterManager.updateGoalAmount(to: newValue) }
                ), in: 500...5000, step: 100) {
                    Text("\(Int(waterManager.registerOfTheDay?.goalAmount ?? 2000)) ml")
                        .font(.title3)
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Editar meta")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}
