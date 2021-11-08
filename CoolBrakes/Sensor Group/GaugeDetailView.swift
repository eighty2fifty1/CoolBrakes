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
    var temp: Int
    var batt: Int
    //var tempResult: FetchedResults<Snapshot>
    @State var tempArray: [Int] = []

    private var numFormatter: NumberFormatter {
        let form = NumberFormatter()
        //form.alwaysShowsDecimalSeparator = false
        form.numberStyle = .none
        return form
    }
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
                Text("MAX: \(numFormatter.string(from: NSNumber(value: modelData.importedSettings.maxObservedTemp[positionIndex])) ?? "46")")
                Text("MIN: \(numFormatter.string(from: NSNumber(value: modelData.importedSettings.minObservedTemp[positionIndex])) ?? "46")")
                Text("AVG: \(numFormatter.string(from: NSNumber(value: modelData.importedSettings.avgObservedTemp[positionIndex])) ?? "46")")
                Button("RESET") {
                    resetMaxMinAvg()
                }
                .buttonStyle(StandardButton())
            }
            VStack {
                SingleSensorView(positionIndex: positionIndex)
                //GaugeView(rawTemp: Double(temp), settings: modelData.importedSettings)
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
    
    func resetMaxMinAvg() {
        modelData.importedSettings.maxObservedTemp[positionIndex] = 0
        modelData.importedSettings.minObservedTemp[positionIndex] = 100
        modelData.importedSettings.avgObservedTemp[positionIndex] = 0

    }
}



struct GaugeDetailView_Previews: PreviewProvider {
    static var modelData = ModelData()
    static let context = PersistenceController.preview.container.viewContext

    static var previews: some View {
        GaugeDetailView(positionIndex: 1, temp: 46, batt: 46, tempArray: [34, 56, 23, 74, 73])
            .environmentObject(modelData)
            .environment(\.managedObjectContext, context)

    }
}
