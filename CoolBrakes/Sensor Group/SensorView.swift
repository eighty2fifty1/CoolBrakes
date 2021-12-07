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
                VStack {
                    NavigationLink(destination: GaugeDetailView(positionIndex: 0, temp: bleManager.LF.temp, batt: bleManager.LF.batt)) {
                        SingleSensorView(positionIndex: 0)
                    }
                    
                        if modelData.importedSettings.axles > 2 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 4, temp: bleManager.LC.temp, batt: bleManager.LC.batt)) {
                                SingleSensorView(positionIndex: 4)
                            }
                        }
                        if modelData.importedSettings.axles > 1 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 2, temp: bleManager.LR.temp, batt: bleManager.LR.batt)) {
                                SingleSensorView(positionIndex: 2)
                            }
                        }
                
                }
                
                
                    Image("trucktrailer")
                        .scaledToFit()
                
                VStack {
                    NavigationLink(destination: GaugeDetailView(positionIndex: 1, temp: bleManager.RF.temp, batt: bleManager.RF.batt)) {
                        SingleSensorView(positionIndex: 1)
                    }
                    
                        if modelData.importedSettings.axles > 2 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 5, temp: bleManager.RC.temp, batt: bleManager.RC.batt)) {
                                SingleSensorView(positionIndex: 5)
                            }
                        }
                        if modelData.importedSettings.axles > 1 {
                            NavigationLink(destination: GaugeDetailView(positionIndex: 3, temp: bleManager.RR.temp, batt: bleManager.RR.batt)) {
                                SingleSensorView(positionIndex: 3)
                            }
                        }
                
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
