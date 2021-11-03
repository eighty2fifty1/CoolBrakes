//
//  ContentView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/4/21.
//

import SwiftUI
import CoreData


enum Tab{
    case home
    case data
    case settings
}

struct ContentView: View {
    
    @State private var selection = 1
    @State private var tripIsActive = false
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    //@EnvironmentObject var colorSettings: ColorSettings
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var notificationManager: Notifications
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var locationManager: LocationManager
    /*
    var avgArray: [[Double]] {
        var array: [[Double]]
        for n in 0...5{
            array[n][0] = modelData.importedSettings.avgObservedTemp[n]
        }
        return array
    }
 */
    
    lazy var avgArray: [[Double]] = [[modelData.importedSettings.avgObservedTemp[0]],
                                     [modelData.importedSettings.avgObservedTemp[1]],
                                     [modelData.importedSettings.avgObservedTemp[2]],
                                     [modelData.importedSettings.avgObservedTemp[3]],
                                     [modelData.importedSettings.avgObservedTemp[4]],
                                     [modelData.importedSettings.avgObservedTemp[5]]
                                    ]
    var sumArray: [Double] = []


    
    private var statusColor: Color {
        if bleManager.isConnected {
            return .green
        } else if bleManager.isScanning {
            return .yellow
        } else {
            return .red
        }
    }
    
    var body: some View {
        VStack {
            Text("Bluetooth Status: \(bleManager.bleStatusMessage)")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .background(statusColor)
            //Text("Signal Strength: \(bleManager.repeaterRSSI ?? "Unknown")")
                
            TabView (selection: $selection) {
                SensorView()
                    .tabItem{Label("Home", systemImage: "gauge")
                    }
                    .tag(1)
                    .environmentObject(bleManager)
                
                DataLoggingView(settings: modelData.importedSettings, tripIsActive: $tripIsActive)
                    .tabItem { Label("Chart", systemImage: "chart.bar")
                    }
                    .tag(2)
                    .environmentObject(bleManager)
                 
    /*      //for debugging
                DummyView()
                    .tabItem { Label("Chart", systemImage: "chart.bar")
                    }
                    .tag(2)
               */
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape")
                    }
                    .tag(3)
                    .environmentObject(bleManager)
            }
            //sends local notifications when conditions are met
            .onReceive(self.bleManager.$incomingIntArray, perform: { _ in
                if !self.bleManager.incomingIntArray.isEmpty{
                    
                    compareMaxMin(posit: bleManager.incomingIntArray[0], temp: bleManager.incomingIntArray[1])
                    
                    //avrage function
                    /*
                    average(posit: bleManager.incomingIntArray[0], temp: bleManager.incomingIntArray[1])
                    */
                    //overtemp alert when temp goes over caution
                    if self.bleManager.incomingIntArray[1] > Int(modelData.importedSettings.alertTemp) {
                        notificationManager.overtempAlert(positIndex: self.bleManager.incomingIntArray[0])
                    }
                    
                    //low battery alert when battery drops below 20%
                    if self.bleManager.incomingIntArray[2] < 20 {
                        notificationManager.lowBatteryAlert(positIndex: self.bleManager.incomingIntArray[0])
                    }
                }
        })

        }
        /*
        .onChange(of: colorScheme) { _ in
            if colorScheme == .dark {
                //self.colorSettings = darkColorSettings
            }
        }
 */
    }
    
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch{
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
}
extension ContentView {

    func compareMaxMin(posit: Int, temp: Int) {
        if posit > 0 {
            let ind = posit - 1
            if modelData.importedSettings.maxObservedTemp[ind] < Double(temp) {
                    modelData.importedSettings.maxObservedTemp[ind] = Double(temp)
            }
            
            if modelData.importedSettings.minObservedTemp[ind] > Double(temp) {
                    modelData.importedSettings.minObservedTemp[ind] = Double(temp)
            }
        }
    }
    /*
    mutating func average(posit: Int, temp: Int) {
        //var avgArray: [Double] = []
        avgArray[3].average()
        avgArray[posit - 1].append(Double(temp))
        sumArray[posit - 1] = avgArray[posit - 1].reduce(0, +)
        modelData.importedSettings.avgObservedTemp[posit - 1] = sumArray[posit - 1] / Double(avgArray[posit - 1].count)
        print("average: \(modelData.importedSettings.avgObservedTemp[posit - 1])")
        
    }
 */
}


struct ContentView_Previews: PreviewProvider {
    static var bleManager = BLEManager()
    //static var locationManager = LocationManager()


    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
            .environmentObject(bleManager)
            .environmentObject(Notifications())
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
            .environmentObject(bleManager)
            .environmentObject(Notifications())
            .colorScheme(.dark)
    }
}

