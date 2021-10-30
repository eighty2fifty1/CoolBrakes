//
//  SensorView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/4/21.
//

import SwiftUI
import UserNotifications

struct SensorView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var bleManager: BLEManager
    
    var tempArray: [Int] {
        return [bleManager.LF.temp, bleManager.RF.temp, bleManager.LR.temp, bleManager.RR.temp, bleManager.LC.temp, bleManager.RC.temp]
    }
    var battArray: [Int] {
        return [bleManager.LF.batt, bleManager.RF.batt, bleManager.LR.batt, bleManager.RR.batt, bleManager.LC.batt, bleManager.RC.batt]
    }
    
    var body: some View {
        NavigationView{
            HStack {
                Spacer()
                VStack{
                    Spacer()
                    if bleManager.LF.batt < 20 {
                        Image(systemName: "battery.25")
                    }
                    Spacer()
                    if bleManager.LC.batt < 20 && modelData.importedSettings.axles > 2{
                        Image(systemName: "battery.25")
                    }
                    Spacer()
                    if bleManager.LR.batt < 20 && modelData.importedSettings.axles > 1 {
                        Image(systemName: "battery.25")
                    }
                    Spacer()

                }
                
                    VStack {
                        NavigationLink(destination: GaugeDetailView(positionIndex: 0, temp: $bleManager.LF.temp, batt: $bleManager.LF.batt)) {
                            GaugeView(rawTemp: Double(bleManager.LF.temp), settings: modelData.importedSettings)
                        }
                        
                            if modelData.importedSettings.axles > 2 {
                                NavigationLink(destination: GaugeDetailView(positionIndex: 4, temp: $bleManager.LC.temp, batt: $bleManager.LC.batt)) {
                                    GaugeView(rawTemp: Double(bleManager.LC.temp), settings: modelData.importedSettings)
                                }
                            }
                            if modelData.importedSettings.axles > 1 {
                                NavigationLink(destination: GaugeDetailView(positionIndex: 2, temp: $bleManager.LR.temp, batt: $bleManager.LR.batt)) {
                                    GaugeView(rawTemp: Double(bleManager.LR.temp), settings: modelData.importedSettings)
                                }
                            }
                    
                    }
                
                
                    Image("trucktrailer")
                        .scaledToFit()
                
                VStack {
                    NavigationLink(destination: GaugeDetailView(positionIndex: 0, temp: $bleManager.RF.temp, batt: $bleManager.RF.batt)) {
                        GaugeView(rawTemp: Double(bleManager.RF.temp), settings: modelData.importedSettings)
                    }
                    
                        if modelData.importedSettings.axles > 2 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 4, temp: $bleManager.RC.temp, batt: $bleManager.RC.batt)) {
                                GaugeView(rawTemp: Double(bleManager.RC.temp), settings: modelData.importedSettings)
                            }
                        }
                        if modelData.importedSettings.axles > 1 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 2, temp: $bleManager.RR.temp, batt: $bleManager.RR.batt)) {
                                GaugeView(rawTemp: Double(bleManager.RR.temp), settings: modelData.importedSettings)
                            }
                        }
                
                }
                
                VStack{
                    Spacer()
                    if bleManager.RF.batt < 20 {
                        Image(systemName: "battery.25")
                    }
                    Spacer()
                    if bleManager.RC.batt < 20 && modelData.importedSettings.axles > 2 {
                        Image(systemName: "battery.25")
                    }
                    Spacer()
                    if bleManager.RR.batt < 20 && modelData.importedSettings.axles > 1 {
                        Image(systemName: "battery.25")
                    }
                    Spacer()

                }
                
                Spacer()
            }
        }
    }

}

extension SensorView {
}

struct SensorView_Previews: PreviewProvider {
    static var modelData = ModelData()
    static var bleManager = BLEManager()
    
    static var previews: some View {
        SensorView()
            .environmentObject(modelData)
            .environmentObject(bleManager)
        
    }
}
