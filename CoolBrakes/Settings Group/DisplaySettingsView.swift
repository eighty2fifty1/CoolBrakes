//
//  DisplaySettingsView.swift
//  CoolBrakes
//
//  Created by James Ford on 11/1/21.
//

import SwiftUI

struct DisplaySettingsView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var bleManager: BLEManager
    
    private var numFormatter: NumberFormatter {
        let form = NumberFormatter()
        //form.alwaysShowsDecimalSeparator = false
        form.numberStyle = .none
        return form
    }
    
    var body: some View {
        VStack {
            Text("Display Settings")
            Spacer()
            HStack{
                Text("Axles")
                Picker("Axles", selection: $modelData.importedSettings.axles) {
                    ForEach(1...3, id: \.self) {i in
                        Text(String(i))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: modelData.importedSettings.axles, perform: { value in
                    bleManager.sendStatusMsg(msg: "<0,\(modelData.importedSettings.axles * 2),0,0,0>")
                })
            }
            .padding()
            
            Spacer()
            Text("Debug val: \(modelData.importedSettings.alertTemp)") //keeping for debugging
            Group{
                EntryFieldView(label: "Alert Temp",field: $modelData.importedSettings.alertTemp, placeHolder: modelData.importedSettings.alertTemp, prompt: modelData.importedSettings.alertPrompt)
                
                EntryFieldView(label: "Min Temp", field: $modelData.importedSettings.minTemp, placeHolder: modelData.importedSettings.minTemp, prompt: modelData.importedSettings.minPrompt)
                
                EntryFieldView(label: "Caution Temp", field: $modelData.importedSettings.cautionTemp, placeHolder: modelData.importedSettings.cautionTemp, prompt: modelData.importedSettings.cautionPrompt)
                
                EntryFieldView(label: "Warning Temp", field: $modelData.importedSettings.warningTemp, placeHolder: modelData.importedSettings.warningTemp, prompt: modelData.importedSettings.warningPrompt)
                
                EntryFieldView(label: "Max Temp", field: $modelData.importedSettings.maxTemp, placeHolder: modelData.importedSettings.maxTemp, prompt: modelData.importedSettings.maxPrompt)
            }
            Spacer()
                Picker("Units", selection: $modelData.importedSettings.metricUnits) {
                    Text("Standard").tag(false)
                    Text("Metric").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            Spacer()
        }
    }
}

extension UIApplication {
    func endEditing () {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DisplaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySettingsView()
            .environmentObject(ModelData())
            .environmentObject(BLEManager())

    }
}
