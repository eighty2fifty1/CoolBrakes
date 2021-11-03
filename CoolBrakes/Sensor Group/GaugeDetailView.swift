//
//  GaugeDetailView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/6/21.
//

import SwiftUI

struct GaugeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var bleManager: BLEManager

    @State var positionIndex: Int
    @Binding var temp: Int
    @Binding var batt: Int
    //var tempResult: FetchedResults<Snapshot>
    @State var tempArray: [Int] = []

    /*
    var avgTemp: Double {
        let tempSum = tempArray.reduce(0, +)
        let avg = Double(tempSum) / Double(tempArray.count)
        //modelData.importedSettings.avgObservedTemp[positionIndex] = avg
        //print(avg)
        return avg
        
    }
 */
    /*
    init(positionIndex: Int) {
        self.positionIndex = positionIndex
        self.tempRequest = FetchRequest(entity: Snapshot.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Snapshot.timestamp, ascending: true)
        ],
        predicate: NSPredicate(format: "posit == %@", positionIndex))
    }
 */
    /*
    @FetchRequest(entity: Snapshot.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Snapshot.timestamp, ascending: true)
    ],
    predicate: NSPredicate(format: "posit == %@", positionIndex)) var trips: FetchedResults<Trip>
    */
    
    //var tempArray: [Double] = []
    public var positName = ["Left Front", "Right Front", "Left Rear", "Right Rear", "Left Center", "Right Center"]
    var body: some View {
        HStack{
            VStack{
                Text("MAX: \(modelData.importedSettings.maxObservedTemp[positionIndex])")
                Text("MIN: \(modelData.importedSettings.minObservedTemp[positionIndex])")
                Text("AVG: \(modelData.importedSettings.avgObservedTemp[positionIndex])")
            }
            VStack {
                GaugeView(rawTemp: Double(temp), settings: modelData.importedSettings)
                Text("POSIT: \(positName[positionIndex])")
            }
            VStack{
                Text("BATT:\(batt)")
                Text("MAC ADDR:")
                Text("RSSI:")
            }
        }
        .onReceive(bleManager.$incomingIntArray, perform: { _ in
            tempArray.append(temp)
            modelData.importedSettings.avgObservedTemp[positionIndex] = Double(tempArray.average())
        })

    }
}



struct GaugeDetailView_Previews: PreviewProvider {
    static var modelData = ModelData()
    static let context = PersistenceController.preview.container.viewContext

    static var previews: some View {
        GaugeDetailView(positionIndex: 1, temp: .constant(46), batt: .constant(46), tempArray: [34, 56, 23, 74, 73])
            .environmentObject(modelData)
            .environment(\.managedObjectContext, context)

    }
}
