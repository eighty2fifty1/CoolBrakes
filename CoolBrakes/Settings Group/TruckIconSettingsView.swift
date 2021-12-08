//
//  TruckIconSettingsView.swift
//  CoolBrakes
//
//  Created by James Ford on 12/8/21.
//

import SwiftUI

struct TruckIconSettingsView: View {
    @EnvironmentObject var modelData: ModelData

    
    var body: some View {
        HStack{
            VStack{
                Text("Hello World")
            }
            TruckIconView(truckColor: .red, dually: modelData.importedSettings.dually, quadCab: modelData.importedSettings.quadCab, sunroof: modelData.importedSettings.sunroof, gooseneck: modelData.importedSettings.gooseneck, trailerColor: .gray)
                .scaledToFit()
        }
    }
}

struct TruckIconSettingsView_Previews: PreviewProvider {
    static var modelData = ModelData()

    
    static var previews: some View {
        TruckIconSettingsView()
            .environmentObject(modelData)
    }
}
