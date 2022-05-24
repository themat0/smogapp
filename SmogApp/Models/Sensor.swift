//
//  Sensor.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 10/05/2022.
//

import Foundation

struct Sensor: Codable, Identifiable {
    //let sensorID: Int32
    let id = UUID()
    let location: Coordinates
    let sensordatavalues: [SensorDataValue]
}

struct SensorSort: Codable, Identifiable, Comparable {
    static func < (lhs: SensorSort, rhs: SensorSort) -> Bool {
        return lhs.distance < rhs.distance
            
    }
    
    static func == (lhs: SensorSort, rhs: SensorSort) -> Bool {
        return lhs.id == rhs.id
    }
    
    //let sensorID: Int32
    let id = UUID()
    let location: Coordinates
    let address: String
    let distance: Int
    var sensordatavalues: SensorData
}

struct Coordinates: Codable {
    let latitude: String
    let altitude: String
    let longitude: String
    let id: Int
    let indoor: Int
}
