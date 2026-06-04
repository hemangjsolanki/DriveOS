//
//  DriveOSApp.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI
import SwiftData
import IQKeyboardManagerSwift

@main
struct DriveOSApp: App {
    init() {
        // Setup IQKeyboardManager globally
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        // Set toolbar appearance to match the app theme
        IQKeyboardManager.shared.keyboardConfiguration.appearance = .dark
        // Set the toolbar text color to our theme's orange
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Vehicle.self, Trip.self, ChargingSession.self])
    }
}
