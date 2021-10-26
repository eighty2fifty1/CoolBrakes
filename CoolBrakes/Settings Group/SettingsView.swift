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
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var bleManager: BLEManager
    @State var sleepAxle: SensorName = .LF
    //@State var axles: Int

    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Settings Page")
            }
            Spacer()
            HStack{
                Text("Axles")
                Picker("Axles", selection: $modelData.importedSettings.axles) {
                    ForEach(1...3, id: \.self) {i in
                        Text(String(i))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Save", action: {
                    bleManager.sendStatusMsg(msg: "<0,\(modelData.importedSettings.axles * 2),0,0,0>")
                })
            }
            Group {
                Spacer()
                Button("Server Reset", action: {
                    bleManager.sendStatusMsg(msg: "<3,0,0,0,0>")
                })
                Spacer()
                Button("Client Software Reset", action: {
                    bleManager.sendStatusMsg(msg: "<1,0,0,0,0>")

                })
                Spacer()
                Button("Client Hardware Reset", action: {
                    bleManager.sendStatusMsg(msg: "<2,0,0,0,0>")
                
                })
                Spacer()
            }
            Group{
                Button("Get MAC Address", action: {
                    bleManager.sendStatusMsg(msg: "<0,0,1,0,0>")

                })
                Spacer()
                Button("Force Scan", action: {
                    bleManager.sendStatusMsg(msg: "<0,0,0,1,0>")

                })
            }
            //dont use enum, doesnt work
            HStack{
                Text("Sleep Sensor")
                Picker("Sleep", selection: $sleepAxle) {
                    ForEach(SensorName.allCases, id: \.self){ sensor in
                        Text(sensor.localizedName)
                            .tag(sensor)
                    }
                    
                }
                .frame(width: 70.0)

                
                Button("Sleep", action: {
                    bleManager.sendStatusMsg(msg: "<0,0,0,0,\(sleepAxle.hashValue)>")
                })
            }
            Button("Sleep All", action: {
                bleManager.sendStatusMsg(msg: "<0,0,0,0,13>")

            })
            Spacer()
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ModelData())
    }
}
