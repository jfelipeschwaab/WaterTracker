// // WaterManager.swift
// Aqua
//
// Created by João Felipe Schwaab on 07/10/25.
//
import Foundation
import SwiftData
import SwiftUI
import WidgetKit
class WaterManager : ObservableObject {
    
    @Published var registerOfTheDay: Water?
    
    let dataController: DatabaseManager
    
    let cloudKitController: CloudKitController
    
    @Published var valueToAlwaysAdd: Double = 200
    
    init(dataController: DatabaseManager, cloudKitController: CloudKitController) {
        self.dataController = dataController
        self.cloudKitController = cloudKitController
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
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func fetchTodayRegister() -> Water? {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else
        {
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
        guard let registerOfTheDay = self.registerOfTheDay else {
            return
        }
        registerOfTheDay.goalAmount = newValue
        dataController.update(element: registerOfTheDay)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func updateTotalAmount() {
        guard let registerOfTheDay = self.registerOfTheDay else {
            return
        }
        if registerOfTheDay.totalAmount >= registerOfTheDay.goalAmount { registerOfTheDay.totalAmount += valueToAlwaysAdd
        }
        registerOfTheDay.totalAmount += valueToAlwaysAdd
        dataController.update(element: registerOfTheDay)
        WidgetCenter.shared.reloadAllTimelines()
        cloudKitController.createCloudKitSubscription()
    }
    
    func updateValueToAlwaysAdd(_ newValue: Double) {
        self.valueToAlwaysAdd = newValue
    }
    
    func resetDailyRegister() {
        self.registerOfTheDay = nil
        createRegister()
        WidgetCenter.shared.reloadAllTimelines()
        cloudKitController.resetSubscription()
    }
    
    func resetProgress() {
        guard let registerOfTheDay = self.registerOfTheDay else {
            return
        }
        registerOfTheDay.totalAmount = 0
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getProgress() -> Double {
        guard let registerOfTheDay = self.registerOfTheDay else {
            print("Não existe um registro para calcular o percentual")
            return 0
        }
        return registerOfTheDay.totalAmount / registerOfTheDay.goalAmount
    }
    
    func getTotalAmount() -> Double {
        guard let registerOfTheDay = self.registerOfTheDay else {
            return 0
        }
        return registerOfTheDay.totalAmount
    }
    
    func getGoalAmount() -> Double {
        guard let registerOfTheDay = self.registerOfTheDay else {
            return 0
        }
        return registerOfTheDay.goalAmount
    }
}
