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
    func colorCard(avgResult: Double, text: String) -> Color {
        if(text == "PM 10"){
            return colorCardPM10(avg: avgResult)
        } else {
            return colorCardPM25(avg: avgResult)
        }
    }
    @ViewBuilder
    func cardPM(item: [Double], text: String) -> some View {
        let avgResult = avg(item: item)
        let color: Color = colorCard(avgResult: avgResult, text: text)
        
        
        VStack {
            Text(String(avgResult))
            Text(text)
        }.padding(10)
            .background(color)
            .cornerRadius(10)
    }
    func colorCardPM10(avg: Double) -> Color{
        if(avg<=20){
            return Color(0.0, 153.0, 0.0)
        } else {
            if(avg <= 50){
                return Color(176, 221, 16)
            } else {
                if(avg <= 80){
                    return Color(255, 217, 15)
                } else {
                    if( avg <= 110){
                        return Color(255, 217, 15)
                    } else {
                        if( avg <= 150){
                            return Color(229, 1, 1)
                        } else {
                            return Color(154, 1, 1)
                        }
                    }
                }
            }
        }
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

struct DetailsView_Previews: PreviewProvider {
    static let sensor = SensorSort(location: Coordinates(latitude: "", altitude: "", longitude: "", id: 1, indoor: 1), address: nil, distance: 1, sensordatavalues: SensorData(P1: [2.0], P2: [2.0]))
    static var previews: some View {
        DetailsView(sensor: sensor)
        
    }
}
