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
    @EnvironmentObject var modelData: ModelData

    @EnvironmentObject var bleManager: BLEManager
    
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

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModelData())
            .environmentObject(bleManager)
            
    }
}
