//
//  SavedTripView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/20/21.
//

import SwiftUI
import SwiftUIMailView

struct SavedTripView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) var editMode

    @Binding var selectedTripIdx: Int
    //@State var isSelected: Bool
    //fetches data from file.
    @FetchRequest(entity: Trip.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)
    ],
    predicate: NSPredicate(format: "name != nil")) var trips: FetchedResults<Trip>

    @State private var tripName: String = "Unknown Name"
    

    var body: some View {
        
        NavigationView {
            
            Form {
                
            List(
            ){
                
                if trips.isEmpty{
                    Text("No Saved Trips")
                }
                
                ForEach(trips, id:\.self) {trip in
                    Button(action: {
                        selectedTripIdx = trips.firstIndex(of: trip) ?? 0
                    }) {
                        HStack {
                            Text(trip.name! + "  " + trip.formattedStartDate)
                        
                        if selectedTripIdx == trips.firstIndex(of: trip) {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                            ExportView(trip: trip)
                            
 
                        }
                    }
                }
                .onDelete(perform: removeTrip)

            }
        }
            .toolbar{
                NavigationLink(
                    destination: TripEditorView(selectedTripIdx: $selectedTripIdx)
                ){
                    Image(systemName: "gearshape")
                    Text("Edit Trip")
                }
            }
        }
    
        /*
        Picker("Trip", selection: $selectedTripIdx) {
        ForEach(trips.indices, id: \.self) { index in
            Text("\(trips[index].name!)").tag(index)
        }
    }
    .frame(width: 75)
 */
    }
    
    func removeTrip(at offsets: IndexSet) {
        for index in offsets {
            let trip = trips[index]
            selectedTripIdx = 0
            viewContext.delete(trip)
            //viewContext.save()
            PersistenceController.shared.save()
        }
    }
}

struct SavedTripView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext

    static var previews: some View {
        SavedTripView(selectedTripIdx: .constant(0))
            .environment(\.managedObjectContext, context)
    }
}
