//
//  Theme.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

enum Theme {
    static let background = Color(hex: "0D0808") // Deep warm black/brown
    static let surface = Color(hex: "1F1413") // Dark reddish-brown for cards
    static let surfaceHighlight = Color(hex: "2D1E1C")
    
    static let primary = Color(hex: "FF6B00") // Vibrant Orange
    static let accent = Color(hex: "FF3B30") // Orange-Red
    
    static let successBg = Color(hex: "0A2514") // Dark green background for pills
    static let successText = Color(hex: "34C759") // Bright green text for pills
    
    static let warningBg = Color(hex: "291605") // Dark orange background for pills
    static let warningText = Color(hex: "FF9500") // Bright orange text for pills
    
    static let warning = Color(hex: "FF9500") // For backward compatibility
    static let danger = Color(hex: "FF3B30") // For backward compatibility
    
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "988E8B")
    
    static let buttonGradient = LinearGradient(
        colors: [Color(hex: "FF6B00"), Color(hex: "FF3B30")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBorder = LinearGradient(
        colors: [Color.white.opacity(0.1), Color.white.opacity(0.02)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

