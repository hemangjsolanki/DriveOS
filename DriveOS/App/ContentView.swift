import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    
    @State private var selectedTab = 0 // Default to Dashboard (0)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.background.ignoresSafeArea()
            
            // Tab Content
            Group {
                switch selectedTab {
                case 0:
                    DashboardView()
                case 1:
                    ChargingCenterView()
                case 2:
                    TripsView()
                case 3:
                    ProfileView()
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                TabBarButton(icon: "house", title: "Home", isSelected: selectedTab == 0) { selectedTab = 0 }
                Spacer()
                TabBarButton(icon: "bolt.batteryblock.fill", title: "Charging", isSelected: selectedTab == 1) { selectedTab = 1 }
                Spacer()
                TabBarButton(icon: "map", title: "Trips", isSelected: selectedTab == 2) { selectedTab = 2 }
                Spacer()
                TabBarButton(icon: "person", title: "Profile", isSelected: selectedTab == 3) { selectedTab = 3 }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Theme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Theme.cardBorder, lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 32) // Exactly 32pt gap from the bottom edge
        }
        .ignoresSafeArea(.all, edges: .bottom) // Ignore the safe area to get precise absolute positioning
    }
}

struct TabBarButton: View {
    var icon: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.caption2.weight(.medium))
            }
            .foregroundColor(isSelected ? Theme.primary : Theme.textSecondary)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Theme.primary.opacity(0.3), lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Theme.primary.opacity(0.1))
                            )
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

