//
//  MultilineChartView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/8/21.
// from medium.com/geekculture by M.Abbas

import SwiftUI
import Charts
import Foundation

struct MultilineChartView: UIViewRepresentable, View {
    @EnvironmentObject var modelData: ModelData

    
    var tempLF: [ChartDataEntry]?
    var tempRF: [ChartDataEntry]?
    var tempLR: [ChartDataEntry]?
    var tempRR: [ChartDataEntry]?
    var tempLC: [ChartDataEntry]?
    var tempRC: [ChartDataEntry]?
    var elevation: [ChartDataEntry]?
    var speed: [ChartDataEntry]?
    var tripTime: Date
    var speedLabel: String {
        if modelData.importedSettings.metricUnits {
            return "KPH"
        }
        return "MPH"
    }
    var altLabel: String {
        if modelData.importedSettings.metricUnits {
            return "METERS"
        }
        return "FEET"
    }
    
    //var tripStartTime: Date
    //var tripArray: [Snapshot]     //removed for troubleshooting
    
    //@Environment(\.managedObjectContext) private var viewContext

    func makeUIView(context: Context) -> LineChartView {
        let chart = LineChartView()
        chart.data = addData()
        return createChart(chart: chart)
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        uiView.data = addData()
    }
    
    //sets chart options
    func createChart(chart: LineChartView) -> LineChartView{
        //chart.pinchZoomEnabled = true
        //chart.dragEnabled = true
        
        //x axis settings
        chart.chartDescription?.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = true
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = .bottom
        //schart.setVisibleXRangeMaximum(1800)
        chart.xAxis.axisMinimum = 0
        //chart.xAxis.axisMaximum = 100 //adding this fixed the issue but this is not a permanent solution.  needs to be conditional for if no data is getting displayed
        
        //wtf, now it works without it??
        
        //chart.xAxis.labelCount = 7
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1
        chart.xAxis.valueFormatter = CustomChartFormatter(sd: tripTime)
        
        //y axis settings
        //chart.leftAxis.axisMaximum = 250
        chart.leftAxis.axisMinimum = 0
        //chart.rightAxis.axisMinimum = 0
        //chart.rightAxis.axisMaximum = 5000
        //chart.leftAxis.enabled = false
        
        chart.data = addData()
        return chart
    }
    
    func addData() -> LineChartData {
        

        let data = LineChartData(dataSets: [
            //temps
            generateLineChartDataSet(dataSetEntries: tempLF, color: UIColor(Color.lf), label: "LF", dependency: .left),
            generateLineChartDataSet(dataSetEntries: tempRF, color: UIColor(Color.rf), label: "RF", dependency: .left),
            generateLineChartDataSet(dataSetEntries: tempLC, color: UIColor(Color.lc), label: "LC", dependency: .left
            ),
            generateLineChartDataSet(dataSetEntries: tempRC, color: UIColor(Color.rc), label: "RC", dependency: .left),
            generateLineChartDataSet(dataSetEntries: tempLR, color: UIColor(Color.lr), label: "LR", dependency: .left),
            generateLineChartDataSet(dataSetEntries: tempRR, color: UIColor(Color.rr), label: "RR", dependency: .left),
            //speed
            generateLineChartDataSet(dataSetEntries: speed, color: UIColor(Color.speed), label: speedLabel, dependency: .left),
            //elevation
            generateLineChartDataSet(dataSetEntries: elevation, color: UIColor(Color.elevation), label: altLabel, dependency: .right)
        
        ])
        return data
    }
    
    //sets line options, i think
    func generateLineChartDataSet(dataSetEntries: [ChartDataEntry]?, color: UIColor, label: String, dependency: YAxis.AxisDependency) -> LineChartDataSet {
        
        var dataSet = LineChartDataSet()
        /*
        if dataSetEntries == nil {
            return LineChartDataSet(entries: [ChartDataEntry(x: 1, y: 1)])
            
        }
        */
        
        dataSet = LineChartDataSet(entries: dataSetEntries, label: "")
        
        
        dataSet.colors = [color]
        dataSet.mode = .linear
        dataSet.drawCirclesEnabled = false
        //dataSet.circleRadius = 5
        //dataSet.circleHoleColor = color
        //dataSet.setCircleColor(UIColor.clear)
        dataSet.lineWidth = 2
        dataSet.valueTextColor = color
        dataSet.valueFont = UIFont(name: "Avenir", size: 12)!
        dataSet.label = label
        dataSet.axisDependency = dependency
        return dataSet
        
    }

    typealias UIViewType = LineChartView
}

struct MultilineChartView_Previews: PreviewProvider {
    static var previews: some View {

        
        MultilineChartView(tempLF: [ChartDataEntry(x: 3, y: 50),
                                    ChartDataEntry(x: 4, y: 3),
                                    ChartDataEntry(x: 5, y: 5)
        
        ] ,
                           tempRF: [ChartDataEntry(x: 3, y: 4),
                                    ChartDataEntry(x: 430000, y: 300)
        
        ],
                           tempLR: [ChartDataEntry(x: 3, y: 130),
                                    ChartDataEntry(x: 4, y: 3)
        
        ],
                           tempRR: [ChartDataEntry(x: 0, y: 270),
                                    ChartDataEntry(x: 4, y: 3)
        
        ],
                           tempLC: [ChartDataEntry(x: 3, y: 1),
                                    ChartDataEntry(x: 4, y: 3)
        
        ],
                           
        tripTime: Date()
        )

    }
}

// MARK: Fix this bug
//  date in x axis does not line up properly.  i think the class only gets generated once regardless of how many times the view changes
class CustomChartFormatter: NSObject, IAxisValueFormatter{
    private var startDate: Date
    
    init(sd: Date) {
        self.startDate = sd
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeInterval: value, since: startDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(for: date) ?? ""
    }
    
    
}
 
