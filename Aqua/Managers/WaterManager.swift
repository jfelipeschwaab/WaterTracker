//
//  WaterManager.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//

import Foundation
import SwiftData
import SwiftUI


class WaterManager : ObservableObject {
    
    @Published var registerOfTheDay: Water?
    let dataController: DatabaseManager
    @Published var valueToAlwaysAdd: Double = 200
    
    
    init(dataController: DatabaseManager) {
        self.dataController = dataController
        createRegister()
    }
    
    func createRegister() {
        if let todayRegister = fetchTodayRegister() {
            self.registerOfTheDay = todayRegister
            return
        }

        let newRegister = Water(date: Date.now, totalAmount: 0, goalAmount: 2000)
        dataController.add(element: newRegister)
        self.registerOfTheDay = newRegister
    }
    
    func fetchTodayRegister() -> Water? {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
            return nil
        }
        
        let predicate = #Predicate<Water> { water in
            water.date >= startOfDay && water.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<Water>(predicate: predicate)
        let results = dataController.getAllElements(fetchDescriptor: descriptor)
        
        return results.first
    }
    
    func updateGoalAmount(to newValue: Double) {
        self.registerOfTheDay?.goalAmount = newValue
    }
    
    func updateTotalAmount() {
        self.registerOfTheDay?.totalAmount += valueToAlwaysAdd
    }
    
    func updateValueToAlwaysAdd(_ newValue: Double) {
        self.valueToAlwaysAdd = newValue
    }
    
    func resetDailyRegister() {
        self.registerOfTheDay = nil
        createRegister()
    }
    
    func getProgress() -> Double {
        if let registerOfTheDay = self.registerOfTheDay {
            return registerOfTheDay.totalAmount / registerOfTheDay.goalAmount
        } else {
            print("Não existe um registro para calcular o percentual")
            return 0
        }
    }
    
    func getTotalAmount() -> Double {
        if let registerOfTheDay = self.registerOfTheDay {
            return registerOfTheDay.totalAmount
        } else {
            print("Não existe um registro")
            return 0
        }
    }
    
    func getGoalAmount() -> Double {
        if let registerOfTheDay = self.registerOfTheDay {
            return registerOfTheDay.goalAmount
        } else {
            print("Não existe um registro")
            return 0
        }
    }
}
