//
//  SplashView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct SplashView: View {
    @Binding var appState: AppState
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo Icon
                ZStack {
                    Circle()
                        .fill(Theme.surfaceHighlight)
                        .frame(width: 120, height: 120)
                        .shadow(color: Theme.primary.opacity(isAnimating ? 0.6 : 0.0), radius: isAnimating ? 40 : 10, x: 0, y: 0)
                    
                    Image(systemName: "bolt.car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .foregroundColor(Theme.primary)
                }
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                
                // App Title
                Text("D R I V E O S")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .tracking(8)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                // Subtitle
                Text("POWER. INTELLIGENCE. MOTION.")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .tracking(2)
                    .opacity(isAnimating ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            // Navigate to appropriate screen after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    if isLoggedIn {
                        appState = .main
                    } else {
                        appState = .auth
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView(appState: .constant(.splash))
}
