//
//  TripsView.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import SwiftUI

struct TripData: Identifiable {
    let id = UUID()
    let date: String
    let location: String
    let distance: String
    let efficiency: String
}

struct TripsView: View {
    let trips = [
        TripData(date: "Today, 9:41 AM", location: "Work • San Francisco", distance: "14.2 mi", efficiency: "264 Wh/mi"),
        TripData(date: "Yesterday, 6:30 PM", location: "Home • San Jose", distance: "45.8 mi", efficiency: "292 Wh/mi"),
        TripData(date: "Oct 24, 2:15 PM", location: "Coffee Shop • Palo Alto", distance: "8.4 mi", efficiency: "240 Wh/mi")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Stats Header
                        HStack(spacing: 16) {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Total Distance")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("12,450 mi")
                                        .font(.title2.bold())
                                        .foregroundColor(Theme.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            GlassCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Avg Efficiency")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                    Text("275 Wh/mi")
                                        .font(.title2.bold())
                                        .foregroundColor(Theme.textPrimary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("Recent Trips")
                            .font(.title2.bold())
                            .foregroundColor(Theme.textPrimary)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // Timeline
                        VStack(spacing: 16) {
                            ForEach(trips) { trip in
                                GlassCard {
                                    HStack(alignment: .top) {
                                        // Timeline Line & Dot
                                        VStack {
                                            Circle()
                                                .fill(Theme.primary)
                                                .frame(width: 12, height: 12)
                                                .padding(.top, 4)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(trip.date)
                                                .font(.caption.bold())
                                                .foregroundColor(Theme.textSecondary)
                                            
                                            Text(trip.location)
                                                .font(.headline)
                                                .foregroundColor(Theme.textPrimary)
                                            
                                            HStack(spacing: 16) {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "map.fill")
                                                        .foregroundColor(Theme.primary)
                                                    Text(trip.distance)
                                                }
                                                
                                                HStack(spacing: 4) {
                                                    Image(systemName: "bolt.fill")
                                                        .foregroundColor(Theme.accent)
                                                    Text(trip.efficiency)
                                                }
                                            }
                                            .font(.subheadline)
                                            .foregroundColor(Theme.textSecondary)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Trips")
        }
    }
}

#Preview {
    TripsView()
}
