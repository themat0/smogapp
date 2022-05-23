//
//  ApiViewModel.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 10/05/2022.
//

import SwiftUI
import CoreLocation

class ApiViewModel: ObservableObject {
    @Published var responds: [Sensor] = []
    @Published var results: [SensorSort] = []
    @StateObject var locationManager = LocationManager()
    
    func fetch(coordinates: String) async{
        guard let url = URL(string: "https://data.sensor.community/airrohr/v1/filter/area="+coordinates+",5&type=SDS011,PMS7003,HPM,PPD42NS,PMS1003,PMS3003,PMS5003,PMS6003") else {
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
                print(results.count > 0)
                if(results.count > 0){
                    for j in 0...results.count-1 {
                        if(results[j].location.id == i.location.id){
                            for k in i.sensordatavalues{
                                if(k.value_type == "P1"){
                                    results[j].sensordatavalues.P1.append(Double(k.value) ?? 0)
                                }
                                if(k.value_type == "P2"){
                                    results[j].sensordatavalues.P2.append(Double(k.value) ?? 0)
                                }
                            }
                            flaga = false
                        }
                    }
                }
                print(self.results)
                if(flaga){
                    await self.newSensor(i:i)
                }
            }
        }catch {
            print(String(describing: error)) // <- ✅ Use this for debuging!
        }
    }
    
    func newSensor(i:Sensor) async{
        var sensorValue = SensorData(P1: [], P2: [])
        for k in i.sensordatavalues{
            
            if(k.value_type == "P1"){
                sensorValue.P1 = [Double(k.value) ?? Double(0)]
            }
            if(k.value_type == "P2"){
                sensorValue.P2 = [Double(k.value) ?? Double(0)]
            }
        }
        let object:SensorSort = await SensorSort(location: i.location, address: getAddress(i.location), sensordatavalues: sensorValue)
        self.results.append(object)
    }
    
    func getAddress(_ coordinates: Coordinates) async -> String {
        var address:String = ""
        do {
            let geoCoder = CLGeocoder()
            let location = CLLocation.init(latitude: Double(coordinates.latitude) ?? 0, longitude: Double(coordinates.longitude) ?? 0)
            let placemarks = try await geoCoder.reverseGeocodeLocation(location)
            address = "\(placemarks.first?.thoroughfare ?? "") \(placemarks.first?.subThoroughfare ?? ""), \(placemarks.first?.locality ?? ""), \(placemarks.first?.administrativeArea ?? "")"
        } catch {
            
        }
        return address
    }
}
