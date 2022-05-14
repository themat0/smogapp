//
//  HomeView.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 10/05/2022.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
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
            ForEach(vm.results){ item in
                //Text(GeotoAdd(item: item))
            }
        }.task {
            let coordinates = "\(userLatitude),\(userLongitude)"
            await vm.fetch(coordinates: coordinates)
            print(vm.results)
            for i in vm.results{
                GeotoAdd(item: i)
            }
        }
    }
    
    func GeotoAdd(item: SensorSort) {
        let address = CLGeocoder.init()
        var readressLabel: String = ""
        address.reverseGeocodeLocation(CLLocation.init(latitude: Double(item.location.latitude) ?? 0, longitude: Double(item.location.longitude) ?? 0)) { (places, error) in
            if error == nil{
                if let place = places{
                    let placeMark = place.last
                    print("\(String(describing: placeMark!.thoroughfare) )\n\(String(describing: placeMark!.postalCode)) \(String(describing: placeMark!.locality))\n\(String(describing: placeMark!.country))")
                    
                }
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
