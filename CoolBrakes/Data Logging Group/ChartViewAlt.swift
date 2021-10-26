//
//  MultilineChartView.swift
//  CoolBrakes
//
//  Created by James Ford on 10/8/21.
//  with help from medium.com/geekculture by M.Abbas

import SwiftUI
import Charts
import Foundation

struct ChartViewAlt: UIViewRepresentable, View {
    
    var tempLF: [ChartDataEntry]

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
        chart.chartDescription?.enabled = false
        chart.xAxis.drawGridLinesEnabled = false
        chart.xAxis.drawLabelsEnabled = true
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.xAxis.labelCount = 7
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        chart.xAxis.granularity = 1
        chart.data = addData()
        return chart
    }
    
    func addData() -> LineChartData {
        let data = LineChartData(dataSets: [
            generateLineChartDataSet(dataSetEntries: tempLF, color: UIColor.green)
        ])
        return data
    }
    
    //sets line options
    func generateLineChartDataSet(dataSetEntries: [ChartDataEntry], color: UIColor) -> LineChartDataSet{
        let dataSet = LineChartDataSet(entries: dataSetEntries, label: "")
        dataSet.colors = [color]
        dataSet.mode = .linear
        dataSet.circleRadius = 5
        dataSet.circleHoleColor = color
        dataSet.setCircleColor(UIColor.clear)
        dataSet.lineWidth = 2
        dataSet.valueTextColor = color
        dataSet.valueFont = UIFont(name: "Avenir", size: 12)!
        return dataSet
    }

    typealias UIViewType = LineChartView
}

struct ChartViewAlt_Previews: PreviewProvider {
    static var previews: some View {
        ChartViewAlt(tempLF: [ChartDataEntry(x: 3, y: 5),
                              ChartDataEntry(x: 4, y: 3),
                              ChartDataEntry(x: 5, y: 5)])
    }
}
