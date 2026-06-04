//
//  SecurityHubView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct SecurityHubView: View {
    @AppStorage("isSentryModeActive") private var isSentryModeActive: Bool = false
    @State private var phase: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Sentry Mode Eye
                        ZStack {
                            Circle()
                                .fill(isSentryModeActive ? RadialGradient(colors: [.red, .black], center: .center, startRadius: 10, endRadius: 100) : RadialGradient(colors: [.gray.opacity(0.3), .black], center: .center, startRadius: 10, endRadius: 100))
                                .frame(width: 200, height: 200)
                                .shadow(color: isSentryModeActive ? .red.opacity(0.8) : .clear, radius: phase == 1 ? 40 : 20)
                            
                            Circle()
                                .fill(isSentryModeActive ? Color.red : Color.gray)
                                .frame(width: 40, height: 40)
                                .blur(radius: isSentryModeActive ? (phase == 1 ? 5 : 2) : 0)
                            
                            Circle()
                                .stroke(Color(white: 0.1), lineWidth: 10)
                                .frame(width: 200, height: 200)
                        }
                        .padding(.top, 40)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                phase = 1
                            }
                        }
                        
                        // Main Control
                        VStack(spacing: 8) {
                            Text(isSentryModeActive ? "Sentry Mode Active" : "Sentry Mode Disabled")
                                .font(.title.bold())
                                .foregroundColor(isSentryModeActive ? .red : Theme.textPrimary)
                            
                            Text(isSentryModeActive ? "Monitoring surroundings. 4 events recorded." : "Vehicle surroundings are not being recorded.")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        Button(action: {
                            let gen = UIImpactFeedbackGenerator(style: .heavy)
                            gen.impactOccurred()
                            withAnimation {
                                isSentryModeActive.toggle()
                            }
                        }) {
                            Text(isSentryModeActive ? "Disable Sentry" : "Enable Sentry")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 200)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(isSentryModeActive ? AnyShapeStyle(Color.red) : AnyShapeStyle(Theme.surfaceHighlight))
                                )
                                .shadow(color: isSentryModeActive ? Color.red.opacity(0.5) : .clear, radius: 15, x: 0, y: 10)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        // Camera Feeds
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Live Cameras")
                                .font(.title3.bold())
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal, 24)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                CameraFeedView(label: "Front", isActive: isSentryModeActive)
                                CameraFeedView(label: "Rear", isActive: isSentryModeActive)
                                CameraFeedView(label: "Left Pillar", isActive: isSentryModeActive)
                                CameraFeedView(label: "Right Pillar", isActive: isSentryModeActive)
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 120)
                    }
                }
            }
            .navigationTitle("Security")
        }
    }
}

struct CameraFeedView: View {
    var label: String
    var isActive: Bool
    
    @State private var staticPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
            
            if isActive {
                // Simulated Static / Scan lines
                VStack(spacing: 2) {
                    ForEach(0..<40, id: \.self) { i in
                        Rectangle()
                            .fill(Color.white.opacity(Double.random(in: 0.05...0.15)))
                            .frame(height: 1)
                            .offset(y: staticPhase == 1 ? 5 : -5)
                    }
                }
                .mask(RoundedRectangle(cornerRadius: 16))
                .animation(.linear(duration: 0.1).repeatForever(autoreverses: true), value: staticPhase)
                
                VStack {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .opacity(staticPhase == 1 ? 1 : 0.2)
                            .animation(.easeInOut(duration: 0.5).repeatForever(), value: staticPhase)
                        Text("REC")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.red)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(12)
            } else {
                Image(systemName: "video.slash.fill")
                    .foregroundColor(Theme.textSecondary)
                    .font(.title)
            }
        }
        .frame(height: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.cardBorder, lineWidth: 1)
        )
        .overlay(
            Text(label)
                .font(.caption.bold())
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding(8),
            alignment: .bottomTrailing
        )
        .onAppear {
            staticPhase = 1
        }
    }
}

#Preview {
    SecurityHubView()
}
