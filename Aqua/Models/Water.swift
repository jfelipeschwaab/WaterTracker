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
    var date: Date
    var totalAmount: Double
    var goalAmount: Double
    
    init(date: Date, totalAmount: Double, goalAmount: Double) {
        self.date = date
        self.totalAmount = totalAmount
        self.goalAmount = goalAmount
    }
}
