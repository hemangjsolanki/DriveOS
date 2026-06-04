//
//  ChargingAttributes.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import Foundation
import ActivityKit

struct ChargingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about the charging activity
        var percentage: Int
        var timeRemaining: String
        var isCharging: Bool
    }
    
    // Fixed non-changing properties about the charging activity
    var vehicleName: String
}
