//
//  GaugeDetailView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/6/21.
//

import SwiftUI

struct GaugeDetailView: View {
    @EnvironmentObject var modelData: ModelData
    @State var positionIndex: Int
    @Binding var temp: Int
    @Binding var batt: Int
    public var positName = ["Left Front", "Right Front", "Left Rear", "Right Rear", "Left Center", "Right Center"]
    var body: some View {
        HStack{
            VStack{
                Text("MAX: \(modelData.importedSettings.maxObservedTemp[positionIndex])")
                Text("MIN: \(modelData.importedSettings.minObservedTemp[positionIndex])")
                Text("AVG: \(modelData.importedSettings.avgObservedTemp[positionIndex])")
            }
            VStack {
                GaugeView(rawTemp: Double(temp), settings: modelData.importedSettings)
                Text("POSIT: \(positName[positionIndex])")
            }
            VStack{
                Text("BATT:\(batt)")
                Text("MAC ADDR:")
                Text("RSSI:")
            }
            
            
        }
    }
}

struct GaugeDetailView_Previews: PreviewProvider {
    static var modelData = ModelData()
    
    static var previews: some View {
        GaugeDetailView(positionIndex: 0, temp: .constant(46), batt: .constant(46))
            .environmentObject(modelData)
    }
}
