//
//  AltTripParser.swift
//  CoolBrakes
//
//
//  Created by James Ford on 10/9/21.
//

import SwiftUI
import Charts

struct AltTripParser: View {
    @Environment(\.managedObjectContext) private var viewContext
    var trip: Trip = Trip()

    var body: some View {
        VStack {
            ChartViewAlt(tempLF: lfTemp)
        }
    }
    
    var lfTemp: [ChartDataEntry] = [ChartDataEntry(x: 3, y: 5),
                                    ChartDataEntry(x: 4, y: 3),
                                    ChartDataEntry(x: 5, y: 9),
                                    ChartDataEntry(x: 6, y: 9)]
    
    //parses array of snapshots into array of ChartDataEntry, by time since trip started
    func parseTemp() -> [ChartDataEntry] {
        var chartData: [ChartDataEntry] = []
        var xVal: Double = 0
        var yVal: Double = 0
        for _ in 0..<5 {
            yVal += 1
            xVal += 1
            
            chartData.append(ChartDataEntry(x: xVal, y: yVal))
        }
        return chartData
    }
}

struct AltTripParser_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        AltTripParser()
            .environment(\.managedObjectContext, context)

    }
}
