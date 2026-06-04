//
//  ConnectingView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct ConnectingView: View {
    @Binding var appState: AppState
    
    @State private var phase: CGFloat = 0
    @State private var textIndex: Int = 0
    @State private var showFinalPulse: Bool = false
    
    let messages = [
        "Establishing BLE Connection...",
        "Handshaking with DriveOS Core...",
        "Authenticating Phone Key...",
        "Waking Vehicle from Sleep...",
        "Connected"
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Radar / Pulse Animation
                ZStack {
                    // Expanding Rings
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .stroke(Theme.primary.opacity(0.5), lineWidth: 2)
                            .frame(width: 100, height: 100)
                            .scaleEffect(phase == 1 ? 4 : 1)
                            .opacity(phase == 1 ? 0 : 0.8)
                            .animation(
                                .easeOut(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.6),
                                value: phase
                            )
                    }
                    
                    // Final Success Pulse
                    if showFinalPulse {
                        Circle()
                            .fill(Theme.primary.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .scaleEffect(5)
                            .opacity(0)
                            .animation(.easeOut(duration: 0.8), value: showFinalPulse)
                    }
                    
                    // Center Icon
                    Circle()
                        .fill(Theme.surface)
                        .frame(width: 120, height: 120)
                        .shadow(color: Theme.primary.opacity(0.3), radius: 20)
                        .overlay(
                            Image(systemName: textIndex == messages.count - 1 ? "checkmark" : "car.fill")
                                .font(.system(size: 40, weight: .light))
                                .foregroundColor(Theme.primary)
                                .symbolEffect(.pulse, options: .repeating, isActive: textIndex < messages.count - 1)
                        )
                }
                
                Spacer()
                
                // Status Feed
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0...textIndex, id: \.self) { index in
                        Text("> " + messages[index])
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .foregroundColor(index == textIndex ? Theme.primary : Theme.textSecondary)
                            .opacity(index == textIndex ? 1.0 : 0.5)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(32)
            }
        }
        .onAppear {
            phase = 1
            simulateConnectionSequence()
        }
    }
    
    private func simulateConnectionSequence() {
        let delays = [0.8, 1.2, 1.0, 1.5]
        var totalDelay: TimeInterval = 0
        
        for (i, delay) in delays.enumerated() {
            totalDelay += delay
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
                withAnimation(.spring()) {
                    textIndex = i + 1
                }
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                // Final state
                if i == delays.count - 1 {
                    let gen = UINotificationFeedbackGenerator()
                    gen.notificationOccurred(.success)
                    withAnimation {
                        showFinalPulse = true
                    }
                    // Transition to Main Dashboard
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            appState = .main
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ConnectingView(appState: .constant(.connecting))
}
