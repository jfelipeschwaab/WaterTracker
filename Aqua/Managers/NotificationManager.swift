//
//  NotificationManager.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//

import Foundation
import UserNotifications
import SwiftUI


final class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    
    private init () {}
    
    private let defaults = UserDefaults.standard
    private let notificationKey = "notificationsEnabledBefore"
    private let intervalKey = "notificationInterval"
    
    @Published var interval : TimeInterval = 7200
    
    var hasSeenNotificationPrompt: Bool {
        return defaults.bool(forKey: notificationKey)
    }
    
    func setHasSeenNotificationPrompt() {
        defaults.set(true, forKey: notificationKey)
    }
    
    func saveInterval(seconds: TimeInterval) {
        interval = seconds
        defaults.set(seconds, forKey: intervalKey)
    }
    
    func loadInterval() {
        if let saved = defaults.object(forKey: intervalKey) as? TimeInterval {
            interval = saved
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void ) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleWaterNotification() {
        let content = UNMutableNotificationContent()
        content.title = "💧 Hora de se hidratar!"
        content.body = "Beba água para manter a hidratação."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        
        let request = UNNotificationRequest(identifier: "waterReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            } else {
                print("Notificação agendada a cada \(Int(self.interval/60)) minutos")
            }
        }
    }
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
