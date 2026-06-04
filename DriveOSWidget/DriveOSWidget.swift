//
//  DriveOSWidget.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import WidgetKit
import SwiftUI
import ActivityKit

@main
struct DriveOSWidgetBundle: WidgetBundle {
    var body: some Widget {
        ChargingActivityWidget()
    }
}

struct ChargingActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ChargingAttributes.self) { context in
            // Lock Screen / Notification Banner UI
            VStack(spacing: 20) {
                // Header section
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            if context.state.isCharging {
                                HStack(spacing: 0) {
                                    Image(systemName: "chevron.right.2")
                                    Image(systemName: "chevron.right.2")
                                }
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.orange)
                                .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: true)
                            } else {
                                Image(systemName: "bolt.slash.fill")
                                    .foregroundColor(.white)
                            }
                            
                            Text(context.state.isCharging ? "HYPERCHARGING" : "STANDBY")
                                .font(.system(.subheadline, design: .rounded).bold())
                                .foregroundColor(context.state.isCharging ? .orange : .white)
                                .tracking(1.5)
                        }
                        
                        if context.state.isCharging {
                            Text(context.state.timeRemaining)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Large Percentage
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(context.state.percentage)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .id(context.state.percentage)
                        Text("%")
                            .font(.headline.bold())
                            .foregroundColor(.gray)
                    }
                }
                
                if context.state.isCharging {
                    // Creative Animated Car Track
                    GeometryReader { geo in
                        let progressWidth = geo.size.width * (CGFloat(context.state.percentage) / 100.0)
                        
                        ZStack(alignment: .leading) {
                            // Background Track
                            Capsule()
                                .fill(Color(white: 0.15))
                                .frame(height: 8)
                                .padding(.top, 14) // Push down to make room for car
                            
                            // Glowing Active Track
                            Capsule()
                                .fill(LinearGradient(colors: [.orange.opacity(0.3), .orange, .red], startPoint: .leading, endPoint: .trailing))
                                .frame(width: max(0, progressWidth), height: 8)
                                .shadow(color: .orange, radius: 10, x: 0, y: 0)
                                .padding(.top, 14)
                            
                            // The Car (rides on top of the track)
                            Image(systemName: "car.side.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 16)
                                .foregroundColor(.white)
                                .shadow(color: .orange, radius: 8, x: -5, y: 0)
                                .symbolEffect(.bounce, options: .repeating, isActive: true)
                                // Offset the car to sit at the exact edge of the progress bar
                                .offset(x: max(0, progressWidth - 32))
                                // iOS 17 automatically interpolates offsets between state updates!
                        }
                    }
                    .frame(height: 22)
                    
                    // Footer Stats
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                            .symbolEffect(.pulse, options: .repeating, isActive: true)
                        Text("+1.2% per min")
                            .font(.caption.bold())
                            .foregroundColor(.orange)
                        Spacer()
                        Text("120 kW")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color(white: 0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(
                        context.state.isCharging ? 
                        LinearGradient(colors: [.orange.opacity(0.8), .red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing) 
                        : LinearGradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), 
                        lineWidth: 1.5
                    )
            )
        } dynamicIsland: { context in
            // Dynamic Island UI
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Image(systemName: context.state.isCharging ? "bolt.car.fill" : "battery.75")
                            .foregroundColor(context.state.isCharging ? .orange : .white)
                            .symbolEffect(.pulse, options: .repeating, isActive: context.state.isCharging)
                        Text(context.state.isCharging ? "HYPERCHARGING" : "READY")
                            .font(.system(.subheadline, design: .rounded).bold())
                            .foregroundColor(context.state.isCharging ? .orange : .white)
                    }
                    .padding(.leading, 4)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("\(context.state.percentage)")
                            .font(.system(.title2, design: .rounded).weight(.black))
                            .contentTransition(.numericText())
                            .id(context.state.percentage)
                        Text("%")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(context.state.isCharging ? .orange : .white)
                    .padding(.trailing, 4)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.isCharging {
                        VStack(spacing: 12) {
                            // Creative Animated Car Track in Dynamic Island!
                            GeometryReader { geo in
                                let progressWidth = geo.size.width * (CGFloat(context.state.percentage) / 100.0)
                                
                                ZStack(alignment: .leading) {
                                    // Background Track
                                    Capsule()
                                        .fill(Color(white: 0.2))
                                        .frame(height: 6)
                                        .padding(.top, 10)
                                    
                                    // Glowing Active Track
                                    Capsule()
                                        .fill(LinearGradient(colors: [.orange.opacity(0.5), .orange, .red], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: max(0, progressWidth), height: 6)
                                        .shadow(color: .orange, radius: 5, x: 0, y: 0)
                                        .padding(.top, 10)
                                    
                                    // Bouncing Car
                                    Image(systemName: "car.side.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 12)
                                        .foregroundColor(.white)
                                        .shadow(color: .orange, radius: 5, x: -2, y: 0)
                                        .symbolEffect(.bounce, options: .repeating, isActive: true)
                                        .offset(x: max(0, progressWidth - 24))
                                }
                            }
                            .frame(height: 16)
                            
                            HStack {
                                HStack(spacing: 0) {
                                    Image(systemName: "chevron.right.2")
                                    Image(systemName: "chevron.right.2")
                                }
                                .font(.caption2.weight(.black))
                                .foregroundColor(.orange)
                                .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: true)
                                
                                Spacer()
                                
                                Text(context.state.timeRemaining)
                                    .font(.caption2.bold())
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.bottom, 4)
                    }
                }
            } compactLeading: {
                // Compact Leading UI
                HStack(spacing: 4) {
                    Image(systemName: context.state.isCharging ? "bolt.car.fill" : "battery.100")
                        .foregroundColor(context.state.isCharging ? .orange : .white)
                        .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: context.state.isCharging)
                }
            } compactTrailing: {
                // Compact Trailing UI
                Text("\(context.state.percentage)%")
                    .font(.system(.subheadline, design: .rounded).weight(.black))
                    .foregroundColor(context.state.isCharging ? .orange : .white)
                    .contentTransition(.numericText())
                    .id(context.state.percentage)
            } minimal: {
                // Minimal UI
                Image(systemName: context.state.isCharging ? "bolt.car.fill" : "battery.100")
                    .foregroundColor(context.state.isCharging ? .orange : .white)
                    .symbolEffect(.variableColor.iterative.reversing, options: .repeating, isActive: context.state.isCharging)
            }
        }
    }
}
