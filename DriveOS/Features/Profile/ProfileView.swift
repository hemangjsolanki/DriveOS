import SwiftUI

struct ProfileView: View {
    @State private var notificationsEnabled = true
    @State private var darkTheme = true
    
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
                                    
                                    Divider().background(Theme.surfaceHighlight)
                                    
                                    Toggle(isOn: $darkTheme) {
                                        HStack {
                                            Image(systemName: "moon.fill")
                                                .foregroundColor(Theme.primary)
                                                .frame(width: 30)
                                            Text("Dark Theme First")
                                                .foregroundColor(Theme.textPrimary)
                                        }
                                    }
                                    .tint(Theme.primary)
                                }
                            }
                            .padding(.horizontal)
                            
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
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
