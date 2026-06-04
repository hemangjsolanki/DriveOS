//
//  BatteryGauge.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct BatteryGauge: View {
    var percentage: Double // 0.0 to 1.0
    var isCharging: Bool
    
    @State private var radarRotation: Double = -90
    @State private var animatedPercentage: Double = 0
    
    var body: some View {
        ZStack {
            // Background track (always dark to avoid double bars)
            Circle()
                .stroke(Color(white: 0.1), style: StrokeStyle(lineWidth: 18, lineCap: .round))
            
            // Inner Radar Sweep (only when charging)
            if isCharging {
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0.0),
                                .init(color: .clear, location: 0.75),
                                .init(color: Theme.primary.opacity(0.1), location: 0.85),
                                .init(color: Theme.primary.opacity(0.8), location: 0.99),
                                .init(color: .clear, location: 1.0)
                            ]),
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360)
                        )
                    )
                    // Padding so the sweep doesn't overlap the outer stroke
                    .padding(9)
                    .rotationEffect(.degrees(radarRotation))
                    .onAppear {
                        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                            radarRotation = 270 // 360 degrees from -90
                        }
                    }
            }
            
            // Progress
            Circle()
                .trim(from: 0, to: animatedPercentage)
                .stroke(
                    Theme.primary,
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: isCharging ? Theme.primary.opacity(0.4) : .clear, radius: 10, x: 0, y: 0)
            
            // Text value
            Text("\(Int(animatedPercentage * 100))%")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animatedPercentage = percentage
            }
        }
        .onChange(of: percentage) { newValue in
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                animatedPercentage = newValue
            }
        }
        .onChange(of: isCharging) { newValue in
            if !newValue {
                radarRotation = -90 // Reset so it can animate again next time
            }
        }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        HStack(spacing: 40) {
            BatteryGauge(percentage: 0.78, isCharging: false)
                .frame(width: 150, height: 150)
            
            BatteryGauge(percentage: 0.78, isCharging: true)
                .frame(width: 150, height: 150)
        }
    }
}
