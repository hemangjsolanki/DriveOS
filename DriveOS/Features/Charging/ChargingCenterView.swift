//
//  ChargingCenterView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI
import ActivityKit

struct ChargingCenterView: View {
    @AppStorage("isCharging") private var isCharging: Bool = true
    @AppStorage("batteryPercent") private var batteryPercent: Int = 78
    @State private var currentActivity: Activity<ChargingAttributes>? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Main Charging Card
                        GlassCard(isGlowing: isCharging) {
                            VStack(spacing: 24) {
                                BatteryGauge(percentage: Double(batteryPercent) / 100.0, isCharging: isCharging)
                                    .frame(width: 200, height: 200)
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        if isCharging {
                                            Image(systemName: "bolt.fill")
                                                .foregroundColor(Theme.primary)
                                        }
                                        Text(isCharging ? "Supercharging" : "Not Charging")
                                            .font(.title2.bold())
                                            .foregroundColor(Theme.textPrimary)
                                    }
                                    
                                    Text(isCharging ? "44 min to full charge • 1.2% per min" : "Connect to supercharger to begin")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                Button(action: toggleCharging) {
                                    Text(isCharging ? "Stop Charging" : "Start Charging")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 200)
                                        .padding(.vertical, 16)
                                        .background(
                                            Capsule()
                                                .fill(isCharging ? AnyShapeStyle(Theme.buttonGradient) : AnyShapeStyle(Theme.surfaceHighlight))
                                        )
                                        .shadow(color: isCharging ? Theme.primary.opacity(0.5) : .clear, radius: 15, x: 0, y: 10)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                }
                                .padding(.top, 8)
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 24)
                        
                        // Stat Cards (Only show when charging)
                        if isCharging {
                            HStack(spacing: 16) {
                                StatCard(title: "Power", value: "225 kW", icon: "bolt.car", accentColor: Theme.primary)
                                StatCard(title: "Time Left", value: "44m", icon: "timer", accentColor: Color.blue)
                                StatCard(title: "Added", value: "+22%", icon: "arrow.up.right", accentColor: Theme.successText)
                            }
                            .padding(.horizontal, 24)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        // Nearby Superchargers
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Nearby Superchargers")
                                .font(.title3.bold())
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 12) {
                                SuperchargerRow(name: "Downtown Supercharger", distance: "0.8 mi away", stalls: "8/12 stalls available", kw: 250)
                                SuperchargerRow(name: "Mall Plaza Station", distance: "2.3 mi away", stalls: "4/8 stalls available", kw: 150)
                                SuperchargerRow(name: "Highway Rest Stop", distance: "5.1 mi away", stalls: "12/16 stalls available", kw: 250)
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.top, 10)
                        
                        // Pro Tips
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Pro Tips")
                                .font(.title3.bold())
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal, 24)
                            
                            GlassCard {
                                VStack(alignment: .leading, spacing: 20) {
                                    TipRow(emoji: "⚡️", text: "Precondition battery before Supercharging for optimal speed")
                                    TipRow(emoji: "🌡️", text: "Charging slows above 80% - plan stops accordingly")
                                    TipRow(emoji: "💰", text: "Off-peak hours (9PM-7AM) save up to 40% on costs")
                                    TipRow(emoji: "🔋", text: "Keep battery between 20-80% for best longevity")
                                }
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.top, 10)
                        
                        Spacer(minLength: 120) // Space for floating tab bar
                    }
                }
            }
        }
    }
    
    private func toggleCharging() {
        withAnimation {
            isCharging.toggle()
        }
        
        if isCharging {
            startLiveActivity()
        } else {
            stopLiveActivity()
        }
    }
    
    private func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = ChargingAttributes(vehicleName: "Model S")
        let initialState = ChargingAttributes.ContentState(
            percentage: batteryPercent,
            timeRemaining: "44 min",
            isCharging: true
        )
        
        let content = ActivityContent(state: initialState, staleDate: nil)
        
        do {
            currentActivity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Failed to start Live Activity: \(error.localizedDescription)")
        }
    }
    
    private func stopLiveActivity() {
        let finalState = ChargingAttributes.ContentState(
            percentage: 78,
            timeRemaining: "Finished",
            isCharging: false
        )
        
        let content = ActivityContent(state: finalState, staleDate: nil)
        
        Task {
            for activity in Activity<ChargingAttributes>.activities {
                await activity.end(content, dismissalPolicy: .immediate)
            }
        }
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var icon: String
    var accentColor: Color
    
    var body: some View {
        GlassCard {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(Theme.textSecondary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                Text(value)
                    .font(.headline.bold())
                    .foregroundColor(Theme.textPrimary)
            }
            .frame(maxWidth: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            VStack {
                Rectangle()
                    .fill(accentColor)
                    .frame(height: 4)
                    .padding(.horizontal, 16)
                Spacer()
            }
        )
    }
}

struct SuperchargerRow: View {
    var name: String
    var distance: String
    var stalls: String
    var kw: Int
    
    var body: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    Text(distance)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                    Text(stalls)
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
                
                Text("\(kw) kW")
                    .font(.caption.bold())
                    .foregroundColor(kw >= 250 ? Theme.successText : Theme.warningText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(kw >= 250 ? Theme.successBg : Theme.warningBg)
                    )
                    .overlay(
                        Capsule()
                            .stroke(kw >= 250 ? Theme.successText.opacity(0.3) : Theme.warningText.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

struct TipRow: View {
    var emoji: String
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(emoji)
                .font(.title3)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Theme.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    ChargingCenterView()
}
