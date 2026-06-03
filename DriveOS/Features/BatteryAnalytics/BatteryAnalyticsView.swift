import SwiftUI
import Charts

struct DailyEnergy: Identifiable {
    let id = UUID()
    let day: String
    let kwh: Double
}

struct BatteryAnalyticsView: View {
    let data: [DailyEnergy] = [
        DailyEnergy(day: "Mon", kwh: 14),
        DailyEnergy(day: "Tue", kwh: 22),
        DailyEnergy(day: "Wed", kwh: 8),
        DailyEnergy(day: "Thu", kwh: 34),
        DailyEnergy(day: "Fri", kwh: 18),
        DailyEnergy(day: "Sat", kwh: 45),
        DailyEnergy(day: "Sun", kwh: 28)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Main Battery Gauge
                        VStack(spacing: 16) {
                            ZStack {
                                BatteryGauge(percentage: 0.78, isCharging: false)
                                    .frame(width: 200, height: 200)
                                    .shadow(color: Theme.primary.opacity(0.3), radius: 30, x: 0, y: 10)
                            }
                            
                            HStack(spacing: 24) {
                                VStack {
                                    Text("Est. Range")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("312 mi")
                                        .font(.title3.bold())
                                        .foregroundColor(Theme.textPrimary)
                                }
                                
                                Divider()
                                    .frame(height: 30)
                                    .background(Theme.surfaceHighlight)
                                
                                VStack {
                                    Text("Health")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("98%")
                                        .font(.title3.bold())
                                        .foregroundColor(Theme.accent)
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        // Energy Consumption Chart
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Weekly Energy Usage")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal)
                            
                            GlassCard {
                                Chart {
                                    ForEach(data) { item in
                                        BarMark(
                                            x: .value("Day", item.day),
                                            y: .value("kWh", item.kwh)
                                        )
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Theme.primary, Theme.primary.opacity(0.4)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .cornerRadius(6)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading) { value in
                                        AxisValueLabel()
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                }
                                .chartXAxis {
                                    AxisMarks { value in
                                        AxisValueLabel()
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                }
                                .frame(height: 220)
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Battery Insights
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Insights")
                                .font(.headline)
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                InsightRow(icon: "leaf.fill", color: Theme.accent, title: "Efficiency", value: "284 Wh/mi")
                                InsightRow(icon: "arrow.down.circle.fill", color: Theme.primary, title: "Regen Energy", value: "14.2 kWh")
                                InsightRow(icon: "bolt.badge.clock.fill", color: Theme.warning, title: "Standby Loss", value: "1.2 kWh")
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

struct InsightRow: View {
    var icon: String
    var color: Color
    var title: String
    var value: String
    
    var body: some View {
        GlassCard {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    BatteryAnalyticsView()
}
