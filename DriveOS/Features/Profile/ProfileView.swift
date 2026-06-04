//
//  ProfileView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct ProfileView: View {
    @Binding var appState: AppState
    
    @State private var notificationsEnabled = true
    @State private var darkTheme = true
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // User Info
                        VStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Theme.primary)
                                .background(Theme.surfaceHighlight)
                                .clipShape(Circle())
                            
                            VStack(spacing: 4) {
                                Text("Hemang Solanki")
                                    .font(.title.bold())
                                    .foregroundColor(Theme.textPrimary)
                                Text("Premium Member")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.accent)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Settings List
                        VStack(spacing: 16) {
                            GlassCard {
                                VStack(spacing: 20) {
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundColor(Theme.primary)
                                            .frame(width: 30)
                                        Text("Connected Vehicles")
                                            .foregroundColor(Theme.textPrimary)
                                        Spacer()
                                        Text("1")
                                            .foregroundColor(Theme.textSecondary)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    
                                    Divider().background(Theme.surfaceHighlight)
                                    
                                    Toggle(isOn: $notificationsEnabled) {
                                        HStack {
                                            Image(systemName: "bell.fill")
                                                .foregroundColor(Theme.warning)
                                                .frame(width: 30)
                                            Text("Push Notifications")
                                                .foregroundColor(Theme.textPrimary)
                                        }
                                    }
                                    .tint(Theme.primary)
                                }
                            }
                            .padding(.horizontal)
                            
                            Button(action: { showingLogoutAlert = true }) {
                                GlassCard {
                                    HStack {
                                        Image(systemName: "arrow.right.square.fill")
                                            .foregroundColor(Theme.danger)
                                            .frame(width: 30)
                                        Text("Sign Out")
                                            .foregroundColor(Theme.danger)
                                        Spacer()
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                            .alert("Sign Out", isPresented: $showingLogoutAlert) {
                                Button("Cancel", role: .cancel) { }
                                Button("Sign Out", role: .destructive, action: signOut)
                            } message: {
                                Text("Are you sure you want to sign out of DriveOS? This will disconnect your vehicle.")
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    private func signOut() {
        // Reset all AppStorage variables and settings
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Return to Login Flow
        withAnimation(.easeInOut(duration: 0.6)) {
            appState = .auth
        }
    }
}

#Preview {
    ProfileView(appState: .constant(.main))
}
