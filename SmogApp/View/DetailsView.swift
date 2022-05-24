//
//  DetailsView.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 24/05/2022.
//

import SwiftUI

struct DetailsView: View {
    var sensor: SensorSort
    
    var body: some View {
        VStack{
            VStack{
            Text(getAddres(item: sensor.address))
                    HStack{
                        cardPM(item: sensor.sensordatavalues.P2, text: "PM 2.5")
                        cardPM(item: sensor.sensordatavalues.P1, text: "PM 10")
                    }
                Text(isIndoor(item:sensor.location))
                Text("na wysokości"  + sensor.location.altitude + "m")
            
            }.padding(20).background(Color.gray.opacity(0.3))
        }.frame(maxWidth: .infinity, alignment: .center).shadow(color: Color.gray, radius: 20, x: 10, y: 10)
       
        //Text("\(sensor.distance) metrów").font(.system(size: 12)).padding(2).frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    func getAddres(item: Address?) -> String{
        return "\(item?.street ?? "") \(item?.number ?? "") , \(item?.city ?? "")"
    }
    
    func isIndoor(item: Coordinates) ->String{
        if(item.indoor == 1){
            return "Czujnik jest położony w środku"
        }
        return "Czujnik jest położony na zewnątrz"
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

struct DetailsView_Previews: PreviewProvider {
    static let sensor = SensorSort(location: Coordinates(latitude: "", altitude: "", longitude: "", id: 1, indoor: 1), address: nil, distance: 1, sensordatavalues: SensorData(P1: [2.0], P2: [2.0]))
    static var previews: some View {
        DetailsView(sensor: sensor)
        
    }
}
