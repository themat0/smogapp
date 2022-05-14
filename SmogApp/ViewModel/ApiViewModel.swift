//
//  ApiViewModel.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 10/05/2022.
//

import SwiftUI

class ApiViewModel: ObservableObject {
    @Published var responds: [Sensor] = []
    @Published var results: [SensorSort] = []
    @StateObject var locationManager = LocationManager()
    
    
    func fetch(coordinates: String) async{
        guard let url = URL(string: "https://data.sensor.community/airrohr/v1/filter/area="+coordinates+",2&type=SDS011,PMS7003,HPM,PPD42NS,PMS1003,PMS3003,PMS5003,PMS6003") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            responds = try JSONDecoder().decode([Sensor].self, from: data)
            var flaga = true
            for i in responds {
                flaga = true
                if(results.count > 0){
                    for j in 0...results.count-1 {
                        if(results[j].location.id == i.location.id){
                            for k in i.sensordatavalues{
                                if(k.value_type == "P0"){
                                    results[j].sensordatavalues.P0.append(k.value)
                                } else {
                                    if(k.value_type == "P1"){
                                        results[j].sensordatavalues.P1.append(k.value)
                                    } else {
                                        results[j].sensordatavalues.P2.append(k.value)
                                    }
                                }
                            }
                            flaga = false
                        }
                    }
                }
                
                if(flaga){
                    var sensorValue = SensorData(P0: [], P1: [], P2: [])
                    for k in i.sensordatavalues{
                        if(k.value_type == "P0"){
                            sensorValue.P0 = [k.value]
                        } else {
                            if(k.value_type == "P1"){
                                sensorValue.P1 = [k.value]
                            } else {
                                sensorValue.P2 = [k.value]
                            }
                        }
                        
                    }
                    results.append(SensorSort(location: i.location, sensordatavalues: sensorValue))
                }
            }
        } catch {
            print(String(describing: error)) // <- ✅ Use this for debuging!
        }
    }
}
