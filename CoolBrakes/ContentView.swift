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
    
    var body: some View {
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
                
                //overtemp alert when temp goes over caution
                if self.bleManager.incomingIntArray[1] > Int(modelData.importedSettings.cautionTemp) {
                    notificationManager.overtempAlert(positIndex: self.bleManager.incomingIntArray[0])
                }
                
                //low battery alert when battery drops below 20%
                if self.bleManager.incomingIntArray[2] < 20 {
                    notificationManager.lowBatteryAlert(positIndex: self.bleManager.incomingIntArray[0])
                }
            }
        })
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



struct ContentView_Previews: PreviewProvider {
    static var bleManager = BLEManager()
    //static var locationManager = LocationManager()


    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
            .environmentObject(bleManager)
            .environmentObject(Notifications())
            
    }
}

