//
//  SettingsView.swift
//  SmogApp
//
//  Created by Mateusz Bereta on 24/05/2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var distance = 5
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Zakres ", selection: $distance) {
                        ForEach(2 ..< 25) {
                            Text("\($0) km")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
