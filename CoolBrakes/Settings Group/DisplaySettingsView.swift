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
    @State var alertTemp: Double?
    @State var minTemp: Double?
    @State var cautionTemp: Double?
    @State var warningTemp: Double?
    @State var maxTemp: Double?
    
    private var numFormatter: NumberFormatter {
        let form = NumberFormatter()
        //form.alwaysShowsDecimalSeparator = false
        form.numberStyle = .none
        return form
    }
    
    var body: some View {
        Form {
            Text("Display Settings")
            HStack{
                Text("Axles")
                Picker("Axles", selection: $modelData.importedSettings.axles) {
                    ForEach(1...3, id: \.self) {i in
                        Text(String(i))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: modelData.importedSettings.axles, perform: { value in
                    if bleManager.isConnected {
                        bleManager.sendStatusMsg(msg: "<0,\(modelData.importedSettings.axles * 2),0,0,0>")
                    }
                })
            }
            .padding()
            
            Text("Debug val: \(alertTemp ?? 46)") //keeping for debugging
            Section{
                Section {
                    EntryFieldView(label: "Alert Temp",field: $alertTemp, placeHolder: modelData.importedSettings.alertTemp, prompt: alertPrompt)
                }
                
                Section {
                    EntryFieldView(label: "Min Temp", field: $minTemp, placeHolder: modelData.importedSettings.minTemp, prompt: minPrompt)
                
                    EntryFieldView(label: "Caution Temp", field: $cautionTemp, placeHolder: modelData.importedSettings.cautionTemp, prompt: cautionPrompt)
                
                    EntryFieldView(label: "Warning Temp", field: $warningTemp, placeHolder: modelData.importedSettings.warningTemp, prompt: warningPrompt)
                
                    EntryFieldView(label: "Max Temp", field: $maxTemp, placeHolder: modelData.importedSettings.maxTemp, prompt: maxPrompt)
                }
                Button("Save Changes", action: {
                    saveGaugeChanges()
                })
                .buttonStyle(StandardButton())
                .disabled(!isInputValidated())
                
            }
                Picker("Units", selection: $modelData.importedSettings.metricUnits) {
                    Text("Standard").tag(false)
                    Text("Metric").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
        }
    }
    
    func saveGaugeChanges() {
        if isInputValidated() {
            modelData.importedSettings.alertTemp = alertTemp! //?? modelData.importedSettings.alertTemp
            modelData.importedSettings.minTemp = minTemp! // ?? modelData.importedSettings.minTemp
            modelData.importedSettings.cautionTemp = cautionTemp! // ?? modelData.importedSettings.cautionTemp
            modelData.importedSettings.warningTemp = warningTemp! // ?? modelData.importedSettings.warningTemp
            modelData.importedSettings.maxTemp = maxTemp! // ?? modelData.importedSettings.maxTemp
        }
    }
}



struct DisplaySettingsView_Previews: PreviewProvider {
    static var modelData = ModelData()
    
    static var previews: some View {
        DisplaySettingsView(alertTemp: modelData.importedSettings.alertTemp, minTemp: modelData.importedSettings.minTemp, cautionTemp: modelData.importedSettings.cautionTemp, warningTemp: modelData.importedSettings.warningTemp, maxTemp: modelData.importedSettings.maxTemp)
            .environmentObject(modelData)
            .environmentObject(BLEManager())

    }
}
