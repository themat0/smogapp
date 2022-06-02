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
    let distance: Int
    init(distance: Int){
        self.distance = distance
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
            await vm.fetch(coordinates: coordinates, distance: distance)
        }.navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    func getAddres(item: Address?) -> String{
        return "\(item?.street ?? "") \(item?.city ?? "")"
    }
    @ViewBuilder
    func cardPM(item: [Double], text: String) -> some View {
        let avgResult = avg(item: item)
        let color: Color = colorCardPM25(avg: avgResult)
        
        VStack {
            Text(String(avgResult))
            Text(text)
        }.padding(10)
            .background(color)
            .cornerRadius(10)
    }
    func colorCardPM25(avg: Double) -> Color{
        if(avg<=13){
            return Color(0.0, 153.0, 0.0)
        } else {
            if(avg <= 35){
                return Color(176, 221, 16)
            } else {
                if(avg <= 55){
                    return Color(255, 217, 15)
                } else {
                    if( avg <= 75){
                        return Color(255, 217, 15)
                    } else {
                        if( avg <= 110){
                            return Color(229, 1, 1)
                        } else {
                            return Color(154, 1, 1)
                        }
                    }
                }
            }
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
    static let disctance = 0
    static var previews: some View {
        HomeView(distance: disctance)
    }
}
extension Color {
    init(_ r: Double,_ g: Double,_ b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
}
