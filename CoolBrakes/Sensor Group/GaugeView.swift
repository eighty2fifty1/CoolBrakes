//
//  GaugeView.swift
//  BrakeSensor
//
//  Created by James Ford on 9/4/21.
//

import SwiftUI
import TTGaugeView

struct GaugeView: View {
    @EnvironmentObject var modelData: ModelData

    var temp: Double
    var settings: Settings
    
    
    //converts temperature values to percents for gauge
    func setGauge(min: Double, max: Double, caution: Double, warning: Double) -> [TTGaugeViewSection] {
        let section : [TTGaugeViewSection] = [TTGaugeViewSection(color: .green, size: (caution - min) / (max - min)),
                TTGaugeViewSection(color: .yellow, size: (warning - caution) / (max - min)),
                TTGaugeViewSection(color: .red, size: (max - warning) / (max - min))]
        
        return section
    }
    
    let angle: Double = 260.0
    
    let gaugeDescription = "Temp"
    
    var body: some View {
        let valueDescription = "\(Int(temp)) deg F"
        //Text(String(settings.maxTemp))
        
            //Text(temp)
            
        TTGaugeView(angle: angle, sections: setGauge(min: settings.minTemp, max: settings.maxTemp, caution: settings.cautionTemp, warning: settings.warningTemp), value: ((temp - settings.minTemp) / (settings.maxTemp - settings.minTemp)), valueDescription: valueDescription, gaugeDescription: gaugeDescription)
    }
}

struct GaugeView_Previews: PreviewProvider {
    static var importedSettings = ModelData().importedSettings
    
    static var previews: some View {
        GaugeView(temp: 50, settings: importedSettings)
    }
}
