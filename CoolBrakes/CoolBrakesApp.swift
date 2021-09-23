//
//  CoolBrakesApp.swift
//  CoolBrakes
//
//  Created by James Ford on 9/23/21.
//

import SwiftUI

@main
struct CoolBrakesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
