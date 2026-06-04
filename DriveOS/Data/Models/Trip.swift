//
//  Trip.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import Foundation
import SwiftData

@Model
final class Trip {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var distanceMiles: Double
    var energyEfficiency: Double // Wh/mi
    var averageSpeed: Double
    
    init(startDate: Date, distanceMiles: Double, energyEfficiency: Double, averageSpeed: Double) {
        self.id = UUID()
        self.startDate = startDate
        self.distanceMiles = distanceMiles
        self.energyEfficiency = energyEfficiency
        self.averageSpeed = averageSpeed
    }
}
