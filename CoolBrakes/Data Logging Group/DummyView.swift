//
//  DummyView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/18/21.
//

import SwiftUI

struct DummyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var bleManager: BLEManager

    
    @FetchRequest(entity: Trip.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)
    ],
    predicate: NSPredicate(format: "name != nil")) var trips: FetchedResults<Trip>
    
    var body: some View{
        ScrollView{
            ForEach(trips[0].snapArray, id: \.self) { snap in
                Text("\(snap.sensorTemp)")

            }
        }
    
    .onReceive(self.bleManager.$incomingIntArray, perform: { _ in
        
            let snap = Snapshot(context: viewContext)
            snap.idSnap = UUID()
            snap.posit = Int16(bleManager.incomingIntArray[0])
            snap.sensorTemp = Int16(bleManager.incomingIntArray[1])
            snap.timestamp = Date()
            trips[0].addToSnapshots(snap)
            
            do {
                try viewContext.save()
                //print("view context saved.\(snap)")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
})
    }
}


struct DummyView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext

    static var previews: some View {
        DummyView()
            .environment(\.managedObjectContext, context)

    }
    
}
