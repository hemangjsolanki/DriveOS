//
//  VehicleRepository.swift
//  DriveOS
//
//  Created by Hemang J Solanki on 04/06/26.
//

import Foundation
import SwiftData

protocol VehicleRepositoryProtocol {
    func fetchVehicles() throws -> [Vehicle]
    func addVehicle(_ vehicle: Vehicle)
    func deleteVehicle(_ vehicle: Vehicle)
    func updateVehicleStatus(id: UUID, isLocked: Bool)
}

final class VehicleRepository: VehicleRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchVehicles() throws -> [Vehicle] {
        let descriptor = FetchDescriptor<Vehicle>()
        return try modelContext.fetch(descriptor)
    }
    
    func addVehicle(_ vehicle: Vehicle) {
        modelContext.insert(vehicle)
        try? modelContext.save()
    }
    
    func deleteVehicle(_ vehicle: Vehicle) {
        modelContext.delete(vehicle)
        try? modelContext.save()
    }
    
    func updateVehicleStatus(id: UUID, isLocked: Bool) {
        let predicate = #Predicate<Vehicle> { $0.id == id }
        let descriptor = FetchDescriptor<Vehicle>(predicate: predicate)
        
        if let vehicle = try? modelContext.fetch(descriptor).first {
            vehicle.isLocked = isLocked
            try? modelContext.save()
        }
    }
}
