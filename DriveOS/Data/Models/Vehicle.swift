//
//  Vehicle.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    var id: UUID
    var name: String
    var model: String
    var batteryPercentage: Double
    var estimatedRangeMiles: Double
    var isLocked: Bool
    var isCharging: Bool
    
    init(name: String, model: String, batteryPercentage: Double, estimatedRangeMiles: Double, isLocked: Bool, isCharging: Bool) {
        self.id = UUID()
        self.name = name
        self.model = model
        self.batteryPercentage = batteryPercentage
        self.estimatedRangeMiles = estimatedRangeMiles
        self.isLocked = isLocked
        self.isCharging = isCharging
    }
}
