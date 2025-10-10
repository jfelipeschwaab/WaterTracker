//
//  Water.swift
//  Aqua
//
//  Created by João Felipe Schwaab on 07/10/25.
//

import Foundation
import SwiftData


@Model
class Water {
    var date: Date = Date.now
    var totalAmount: Double = 0
    var goalAmount: Double = 0
    
    init(date: Date, totalAmount: Double, goalAmount: Double) {
        self.date = date
        self.totalAmount = totalAmount
        self.goalAmount = goalAmount
    }
}
