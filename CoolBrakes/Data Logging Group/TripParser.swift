//
//  TripParser.swift
//  CoolBrakes
//
//  Created by James Ford on 10/9/21.
//

import SwiftUI
import Charts

struct TripParser: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var modelData: ModelData

    //var trip = FetchedResults<Trip>.Element
    @ObservedObject var trip: Trip
    
    @Binding var dispLF: Bool
    @Binding var dispRF: Bool
    @Binding var dispLR: Bool
    @Binding var dispRR: Bool
    @Binding var dispLC: Bool
    @Binding var dispRC: Bool
    @Binding var dispSpeed: Bool
    @Binding var dispElevation: Bool
    
    
    public var tripTime: Date {
        return trip.startDate ?? Date() //should protect from nil value
    }
    //
    
    //var tripArray: [Snapshot] = []
    
    private var lf: [ChartDataEntry]? {
        if dispLF {
            return parseTemp(sortedSnapArray: sortPositions(index: 1, snapArray: trip.snapArray))
        }
        return nil
    }
    private var rf: [ChartDataEntry]? {
        if dispRF {
            return parseTemp(sortedSnapArray: sortPositions(index: 2, snapArray: trip.snapArray))
        }
        return nil
    }
    private var lr: [ChartDataEntry]? {
        if dispLR {
            return parseTemp(sortedSnapArray: sortPositions(index: 3, snapArray: trip.snapArray))
        }
        return nil
    }
    private var rr: [ChartDataEntry]? {
        if dispRR {
            return parseTemp(sortedSnapArray: sortPositions(index: 4, snapArray: trip.snapArray))
        }
        return nil
    }
    private var lc: [ChartDataEntry]? {
        if dispLC {
            return parseTemp(sortedSnapArray: sortPositions(index: 5, snapArray: trip.snapArray))
        }
        return nil
    }
    private var rc: [ChartDataEntry]? {
        if dispRC {
            return parseTemp(sortedSnapArray: sortPositions(index: 6, snapArray: trip.snapArray))
        }
        return nil
    }
    
    private var speedPlot: [ChartDataEntry]? {
        if dispSpeed {
            return parseSpeed(snapArray: trip.snapArray)
        }
        return nil
    }
    
    private var elevPlot: [ChartDataEntry]? {
        if dispElevation {
            return parseElevation(snapArray: trip.snapArray)
        }
        return nil
    }
    
    /*
    private var speed: [ChartDataEntry] {
        var s: [ChartDataEntry]
        for n in 0..<trip.snapArray.count {
            s.append(parseTemp(sortedSnapArray: <#T##[Snapshot]#>))
        }
    }
 */

    var body: some View {
        VStack {
            //Text("\(trip)")
            
            MultilineChartView(tempLF: lf, tempRF: rf, tempLR: lr, tempRR: rr, tempLC: lc, tempRC: rc, elevation: elevPlot, speed: speedPlot, tripTime: tripTime
            )
        }
    }
    //var arrayOfTrips: [Trip]
//var tripArrayCount: Int
    
    //sorts incoming array of snapshots by position
    func sortPositions(index: Int, snapArray: [Snapshot]) -> [Snapshot] {
        
        let lfTemp: [Snapshot] = []
        let rfTemp: [Snapshot] = []
        let lrTemp: [Snapshot] = []
        let rrTemp: [Snapshot] = []
        let lcTemp: [Snapshot] = []
        let rcTemp: [Snapshot] = []
        
        var returnArray = [lfTemp, rfTemp, lrTemp, rrTemp, lcTemp, rcTemp]
       
        for n in 0..<snapArray.count {
            switch snapArray[n].posit {
            case 1:
                returnArray[0].append(snapArray[n])
            case 2:
                returnArray[1].append(snapArray[n])
            case 3:
                returnArray[2].append(snapArray[n])
            case 4:
                returnArray[3].append(snapArray[n])
            case 5:
                returnArray[4].append(snapArray[n])
            case 6:
                returnArray[5].append(snapArray[n])
            default:
                return returnArray[index - 1]
            }
        }
        return returnArray[index - 1]
    }
    
    
    //parses array of snapshots into array of ChartDataEntry, by time since trip started.  input is always in Farenheit
    func parseTemp(sortedSnapArray: [Snapshot]) -> [ChartDataEntry] {
        var chartData: [ChartDataEntry] = []
        var xVal: Double = 0
        var yVal: Double = 0
        for n in 0..<sortedSnapArray.count {
            
            //conditionally convets to C
            if modelData.importedSettings.metricUnits {
                yVal = (Double(sortedSnapArray[n].sensorTemp) - 32 ) * 5 / 9
            } else {
                yVal = Double(sortedSnapArray[n].sensorTemp)
            }
            xVal = sortedSnapArray[n].timestamp!.timeIntervalSince(tripTime)
            
            chartData.append(ChartDataEntry(x: xVal, y: yVal))
        }
        return chartData
    }
    
    //charts elevation. input is always in feet
    func parseElevation(snapArray: [Snapshot]) -> [ChartDataEntry] {
        var chartData: [ChartDataEntry] = []
        var xVal: Double = 0
        var yVal: Double = 0
        for n in 0..<snapArray.count {
            
            //conditionally converts to meters
            if modelData.importedSettings.metricUnits {
                yVal = snapArray[n].altitude / 3.281
            } else {
                yVal = snapArray[n].altitude
            }
            xVal = snapArray[n].timestamp!.timeIntervalSince(tripTime)
            chartData.append(ChartDataEntry(x: xVal, y: yVal))
        }
        return chartData
    }
    
    //charts speed. input is always in mph
    func parseSpeed(snapArray: [Snapshot]) -> [ChartDataEntry] {
        var chartData: [ChartDataEntry] = []
        var xVal: Double = 0
        var yVal: Double = 0
        for n in 0..<snapArray.count {
            
            //conditionally converts to kph
            if modelData.importedSettings.metricUnits {
                yVal = snapArray[n].speed * 1.609
            } else {
                yVal = snapArray[n].speed
            }
            xVal = snapArray[n].timestamp!.timeIntervalSince(tripTime)
            chartData.append(ChartDataEntry(x: xVal, y: yVal))
        }
        return chartData
    }
}

struct TripParser_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let previewTrip = PersistenceController.preview.container.viewContext.registeredObjects.first(where: {$0 is Trip}) as! Trip
        
        //must use .constant for bindings
        TripParser(trip: previewTrip, dispLF: .constant(false), dispRF: .constant(false), dispLR: .constant(false), dispRR: .constant(false), dispLC: .constant(false), dispRC: .constant(false), dispSpeed: .constant(false), dispElevation: .constant(false))
            .environment(\.managedObjectContext, context)
    }
}
