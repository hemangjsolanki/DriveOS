//
//  ChargingSession.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import Foundation
import SwiftData

@Model
final class ChargingSession {
    var id: UUID
    var startDate: Date
    var endDate: Date?
    var energyAddedKWh: Double
    var cost: Double
    var locationName: String
    
    init(startDate: Date, energyAddedKWh: Double, cost: Double, locationName: String) {
        self.id = UUID()
        self.startDate = startDate
        self.energyAddedKWh = energyAddedKWh
        self.cost = cost
        self.locationName = locationName
    }
}
