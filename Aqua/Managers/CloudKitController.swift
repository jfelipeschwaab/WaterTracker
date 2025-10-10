//
//  CloudKitController.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 09/10/25.
//

import Foundation
import SwiftData
import CloudKit


class CloudKitController {
    
    let subscriptionGoal = "goal-reached-subscription"
    
    init(){}
    
    
    func createCloudKitSubscription() {
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: subscriptionGoal) {
            print("Assinatura do CloudKit já existe")
            return
        }
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "CD_Water", predicate: predicate, subscriptionID: subscriptionGoal, options: [.firesOnRecordUpdate])
        
        
        let notificationInfo = CKSubscription.NotificationInfo()
        
        notificationInfo.title = "Meta Atingida! 🏆"
        notificationInfo.alertBody = "Parabéns, você completou sua meta de hidratação de hoje! 💧"
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        
        let database = CKContainer.default().privateCloudDatabase
        database.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print("Erro ao salvar a assinatura do CloudKit: \(error.localizedDescription)")
            } else {
                print("Assinatura do CloudKit criada com sucesso!")
                defaults.set(true, forKey: self.subscriptionGoal)
            }
        }
    }
    
    func resetSubscription() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: subscriptionGoal)
    }
}
