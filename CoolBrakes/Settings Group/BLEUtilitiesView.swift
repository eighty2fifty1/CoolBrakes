//
//  BLEUtilitiesView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import SwiftUI

struct BLEUtilitiesView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State var sleepAxle: SensorName = .LF
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Bluetooth Utilities")
            }
            Spacer()
            
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
                Spacer()
                
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
        .buttonStyle(StandardButton())

    }
}

struct BLEUtilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        BLEUtilitiesView()
    }
}
