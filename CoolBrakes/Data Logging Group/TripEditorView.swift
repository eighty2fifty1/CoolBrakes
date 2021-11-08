//
//  TripEditorView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/26/21.
//

import SwiftUI

struct TripEditorView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @Binding var selectedTripIdx: Int
    @State var tripName: String
    @State var tripNotes: String = " "
    @State private var showingAlert = false

    //fetches data from file.
    @FetchRequest(entity: Trip.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Trip.startDate, ascending: false)
    ],
    predicate: NSPredicate(format: "name != nil")) var trips: FetchedResults<Trip>
    
    var body: some View {
        Form{
            HStack{
                Text("Trip Name")
                TextField("\(trips[selectedTripIdx].name!)", text: $tripName)
            }
            Text("Trip Notes")
            TextEditor(text: $tripNotes)
            Button(action: {
                showingAlert = true
            }, label: {
                Text("Save Changes")
            })
        }
        
        .actionSheet(isPresented: $showingAlert) {
            ActionSheet(title: Text("Save Changes?"), buttons: [
                            .default(Text("Save"), action: {
                                trips[selectedTripIdx].name = tripName
                                trips[selectedTripIdx].tripNotes = tripNotes
                                PersistenceController.shared.save()
                                showingAlert = false
                            }),
                            .cancel(Text("Cancel"), action: {
                                showingAlert = false
                            })])
        }
        /*
        .onDisappear(perform: {
            showingAlert = true
            print("View did disappear")
        })
 */
    }
}

struct TripEditorView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        TripEditorView(selectedTripIdx: .constant(0), tripName: "Trip 1")
            .environment(\.managedObjectContext, context)

    }
}
