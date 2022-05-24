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
        NavigationView {
            Form {
                List(vm.results.sorted()){ item in
                    NavigationLink(destination: DetailsView(sensor: item)){
                        HStack{
                            cardPM(item: item.sensordatavalues.P2, text: "PM 2.5")
                            Text(getAddres(item: item.address))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                       
                        Text("\(item.distance) metrów").font(.system(size: 12)).padding(2).frame(maxHeight: .infinity, alignment: .bottom)
                         
                    }
                }
                if(vm.results.count == 0){
                    Text("Lista jest pusta")
                }
            }.navigationBarTitle("Smog App", displayMode: .automatic)
        }.task {
            let coordinates = CLLocation(latitude: Double(userLatitude) ?? 0.0, longitude: Double(userLongitude) ?? 0.0)
            await vm.fetch(coordinates: coordinates)
        }
    }
    
    func getAddres(item: Address?) -> String{
        return "\(item?.street ?? "") \(item?.city ?? "")"
    }
    @ViewBuilder
    func cardPM(item: [Double], text: String) -> some View {
        let avgResult = avg(item: item)
        let color: Color = colorCard(avg: avgResult)
        
        VStack {
            Text(String(avgResult))
            Text(text)
        }.padding(10)
            .background(color)
            .cornerRadius(10)
    }
    func colorCard(avg: Double) -> Color{
        if(avg>20){
            return Color.red
        } else {
            return Color.green
        }
    }
    func avg(item:[Double]) -> Double{
        var sum = 0.0
        for i in item{
            sum += i
        }
        let result = sum / Double(item.count)
        return Double(round(100 * result) / 100)
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
