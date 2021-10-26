//
//  DataLogging.swift
//  BrakeSensor
//
//  Created by James Ford on 9/15/21.
//

import SwiftUI
import Charts
import OSLog
import CoreData
import CoreGraphics

struct DataLoggingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var modelData: ModelData
    var settings: Settings
    //public var activeTrip: Trip { return Trip(context: viewContext) }
    @EnvironmentObject var bleManager: BLEManager



    //fetches data from file.
    @FetchRequest(entity: Trip.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)
    ],
    predicate: NSPredicate(format: "name != nil")) var trips: FetchedResults<Trip>

    @State var showSettings = false
    //StateObject var selectedTrip: Trip
    
    
    
    @State var selectedTripIdx: Int = 0
    @State var dispLF = true
    @State var dispRF = true
    @State var dispLR = true
    @State var dispRR = true
    @State var dispLC = true
    @State var dispRC = true
    @State var showTripAlert = false
    
    @Binding var tripIsActive: Bool

        
    //var newTrip: Trip = Trip()
    //var currentTrip: Trip = tripData.first!
    //var values: [Int16] = []
    
    let defaultName = "Unknown Name"
    let defaultDate = "Unknown Date"
    let tripActiveMsg = "Trip is Active"
    let tripInactiveMsg = "End Trip"
    @State var tripMsgTitle = ""
    
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        return dateFormatter
    }
    
    var blankTrip: Trip {
        let trip = Trip(context: viewContext)
        
        trip.startDate = Date()
        trip.idTrip = UUID()
        trip.name = "Blank Trip"
        
        return trip
    }
    
    

    var body: some View {
        NavigationView {
            VStack {
                //Spacer()
                HStack {
                    //start trip button
                    Button(action: {
                        if tripIsActive == true {
                            showTripAlert = true
                            tripMsgTitle = tripActiveMsg
                        }
                        else {
                            tripIsActive = true
                            startNewTrip()
                        }
                    }) {
                        Image(systemName: "plus.rectangle")
                        Text("Start New Trip")
                            
                    }
                    .padding(.leading)
                    .actionSheet(isPresented: $showTripAlert) {
                        ActionSheet(title: Text(tripMsgTitle), buttons: [
                                        .default(Text("Save Current Trip"), action: {
                                            if tripIsActive {
                                                startNewTrip()
                                            }
                                            
                                        }),
                                        .default(Text("Discard Current Trip "), action: {
                                            discardCurrentTrip()
                                            startNewTrip()
                                            
                                        }),
                                        .cancel()])
                        
                }
                    if tripIsActive == true {
                        Spacer()
                        
                        //end trip button
                        Button(action: {
                                showTripAlert = true
                                tripMsgTitle = tripInactiveMsg
                            tripIsActive = false  //TODO:  this needs to be changed to add a confirmation message
                        }) {
                            Image(systemName: "stop.circle")
                            Text("End Trip")
                                
                            }
                        .padding(.trailing)
                    }
                }
                Spacer()
        
                if trips.isEmpty {
                    Text("No Trips Available")
                    Spacer()
                } else {
                    TripParser(trip: trips[selectedTripIdx], dispLF: $dispLF, dispRF: $dispRF, dispLR: $dispLR, dispRR: $dispRR, dispLC: $dispLC, dispRC: $dispRC)
                }
                HStack{
                    Text("Settings")
                    
                    Button(action: {
                        self.showSettings.toggle()
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .rotationEffect(.degrees(showSettings ? 90 : 0))
                            .animation(.easeInOut)
                    }
                    
                    
                }
                if showSettings {
                    HStack {
                        VStack {
                            if !trips.isEmpty {
                            Text("Start Date: \(formatter.string(from: trips[selectedTripIdx].startDate ?? Date()))")
                                .padding(.top, 32.0)
                            Text("Trip Name: \(trips[selectedTripIdx].name ?? defaultName)")
                            }
                            Spacer()
                            
                            NavigationLink(
                                destination: SavedTripView(selectedTripIdx: $selectedTripIdx)) {
                                    Image(systemName: "map.fill")
                                    Text("Saved Trips")
                                }
 
                            .padding(32.0)
                            
                        
                            
                        }
                        
                        
                        VStack {
                            Text("Display Axle")
                            Toggle(isOn: $dispLF){
                                Text("Left Front")
                            }
                            .frame(width: 150.0)
                            Toggle(isOn: $dispRF){
                                Text("Right Front")
                            }
                            .frame(width: 150.0)
                            
                            if (settings.axles > 1) {
                                Toggle(isOn: $dispLR){
                                    Text("Left Rear")
                                }
                                .frame(width: 150.0)
                                Toggle(isOn: $dispRR){
                                    Text("Right Rear")
                                }
                                .frame(width: 150.0)
                                
                                if settings.axles > 2 {
                                    
                                    Toggle(isOn: $dispLC){
                                        Text("Left Center")
                                    }
                                    .frame(width: 150.0)
                                    Toggle(isOn: $dispRC){
                                        Text("Right Center")
                                    }
                                    .frame(width: 150.0)
                                }
                            }
                        }
                    }
                }
            }
            .onReceive(self.bleManager.$incomingIntArray, perform: { _ in
                if tripIsActive {
                    let snap = Snapshot(context: viewContext)
                    snap.idSnap = UUID()
                    snap.posit = Int16(bleManager.incomingIntArray[0])
                    snap.sensorTemp = Int16(bleManager.incomingIntArray[1])
                    snap.timestamp = Date()
                    trips[selectedTripIdx].addToSnapshots(snap)
                    
                    do {
                        try PersistenceController.shared.save()
                        print("view context saved.\(snap)")
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    

                }
        })
        }
        //.navigationBarHidden(true)
    }
    
    func startNewTrip() {
        let newTrip = Trip(context: viewContext)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        newTrip.idTrip = UUID()
        newTrip.startDate = Date()
        newTrip.name = "Trip"
        
        PersistenceController.shared.save()
    }
    
    func discardCurrentTrip() {
        
    }
    /*
    func setDefaultTrip() -> Trip {
        guard let defaultTrip = trips.last else { return newTrip }
        return defaultTrip
    
    }
    */

}
/*
extension Array {
    subscript (safe index: Index) -> Element {
        return indices.contains(index) ? self[index] : nil
    }
}
*/
struct DataLoggingView_Previews: PreviewProvider {
    static var importedSettings = ModelData().importedSettings
    static var bleManager = BLEManager()


    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        
        DataLoggingView(settings: importedSettings, showSettings: true, tripIsActive: .constant(false))
            .environment(\.managedObjectContext, context)
            .environmentObject(bleManager)
    }
}