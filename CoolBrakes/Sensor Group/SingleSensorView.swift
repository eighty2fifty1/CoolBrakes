//
//  SingleSensorView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/8/21.
//

import SwiftUI

struct SingleSensorView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var bleManager: BLEManager
    
    var positionIndex: Int
    
    var tempArray: [Int] {
        return [bleManager.LF.temp, bleManager.RF.temp, bleManager.LR.temp, bleManager.RR.temp, bleManager.LC.temp, bleManager.RC.temp]
    }
    
    var battArray: [Int] {
        return [bleManager.LF.batt, bleManager.RF.batt, bleManager.LR.batt, bleManager.RR.batt, bleManager.LC.batt, bleManager.RC.batt]
    }
    
    var body: some View {
        HStack {
            VStack {
                IndicatorLEDView(sensorStatus: bleManager.incomingStatusArray[positionIndex] )
                if battArray[positionIndex] < 20 {
                    Image(systemName: "battery.25")
                }
            }
            NavigationLink(destination: GaugeDetailView(positionIndex: positionIndex, temp: tempArray[positionIndex], batt: battArray[positionIndex])) {
                GaugeView(rawTemp: Double(tempArray[positionIndex]), settings: modelData.importedSettings)
            }
        }
    }
}

struct SingleSensorView_Previews: PreviewProvider {
    static var modelData = ModelData()
    static var bleManager = BLEManager()
    
    static var previews: some View {
        SingleSensorView(positionIndex: 3)
            .environmentObject(modelData)
            .environmentObject(bleManager)
    }
}
