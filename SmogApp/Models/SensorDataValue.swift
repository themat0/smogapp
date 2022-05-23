//
//  SensorDataValue.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 12/05/2022.
//

import Foundation

struct SensorDataValue: Codable, Identifiable {
    let id = UUID()
    let value: String
    let value_type: String
}

struct SensorData: Codable {
    var P1: [Double]
    var P2: [Double]
}
