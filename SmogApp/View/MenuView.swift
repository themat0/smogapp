//
//  MenuView.swift
//  SmogApp
//
//  Created by Kinga Kotowicz on 24/05/2022.
//

import SwiftUI

import CoreLocation

struct MenuView: View {
    @State private var distance = 5
    var body: some View {
        NavigationView{
            VStack{
                Text("Wybierz promień wyszukań:").font(.system(size:22))
                    Picker("Zakres ", selection: $distance) {
                        ForEach(2 ..< 25) {
                        Text("\($0) km").font(.system(size:22))}
                     }
                NavigationLink(destination: HomeView(distance: distance)){
                    Text("Przejdź dalej").padding(15)
                }.border(.gray).padding(20)
            }.navigationBarTitleDisplayMode(.large).toolbar{
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Smog App").font(.system(size: 55)).foregroundColor(.white).padding(0).background(Ellipse().fill(.gray).frame(width: 450, height: 300)).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    }
                }
            }
        }
    }
}
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
