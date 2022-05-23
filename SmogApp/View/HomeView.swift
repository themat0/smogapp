//
//  HomeView.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 10/05/2022.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    var locs: [String?] = []
    @StateObject var locationManager = LocationManager()
    @StateObject var vm = ApiViewModel()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        VStack {
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("latitude: \(userLatitude)")
                Text("longitude: \(userLongitude)")
            }
            List(vm.results){ item in
                Group{
                    HStack{
                        VStack {
                            Text("PM2.5: \(avg(item: item.sensordatavalues.P2))")
                            Text("PM10: \(avg(item: item.sensordatavalues.P1))")
                        }
                        Text(item.address)
                    }
                }
            }
        }.task {
            let coordinates = "\(userLatitude),\(userLongitude)"
            await vm.fetch(coordinates: coordinates)
            print(vm.results)
        }
    }
    
    func avg(item:[Double]) -> String{
        var sum = 0.0
        for i in item{
            sum += i
        }
        let result = sum / Double(item.count)
        return String(Double(round(100 * result) / 100))
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
