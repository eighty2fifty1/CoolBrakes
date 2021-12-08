//
//  SettingsView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/6/21.
//

import SwiftUI

enum SensorName: String, Equatable, CaseIterable {
    case LF = "LF"
    case RF = "RF"
    case LC = "LC"
    case RC = "RC"
    case LR = "LR"
    case RR = "RR"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct SettingsView: View {

    //@State var metricUnits = false
    //@State var axles: Int

    var body: some View {
        TabView {
            BLEUtilitiesView()
            DisplaySettingsView()
            TruckIconSettingsView()
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ModelData())

        SettingsView()
            .environmentObject(ModelData())
            .colorScheme(.dark)
    }
}
