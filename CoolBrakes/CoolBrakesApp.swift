//
//  CoolBrakesApp.swift
//  CoolBrakes
//
//  Created by James Ford on 9/23/21.
//
//with help from blckbirds.com/post/core-data-and-swiftui/

import SwiftUI

@main
struct CoolBrakesApp: App {
    @StateObject private var modelData = ModelData()
    @StateObject var bleManager = BLEManager()
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(modelData)
                .environmentObject(bleManager)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
    
}