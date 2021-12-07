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
    //@EnvironmentObject var colorSettings: ColorSettings
    //@Binding var metricUnits: Bool
    var rawTemp: Double     //comes in as F
    var convertedTemp: Double {
        if modelData.importedSettings.metricUnits {
            return (rawTemp - 32) * (5 / 9) //converts to C if true
        }
        return rawTemp
    }
    var settings: Settings
    let gaugeSettings = TTGaugeViewSettings(faceColor: Color.gaugeFace, needleColor: Color.needle)
    
    var valueDescription: String {
        if modelData.importedSettings.metricUnits {
         return "\(Int(convertedTemp)) °C"
        }
    return "\(Int(convertedTemp)) °F"
    }
    
    //converts temperature values to percents for gauge
    func setGauge(min: Double, max: Double, caution: Double, warning: Double) -> [TTGaugeViewSection] {
        let section : [TTGaugeViewSection] = [TTGaugeViewSection(color: Color.normal, size: (caution - min) / (max - min)),
                                              TTGaugeViewSection(color: Color.caution, size: (warning - caution) / (max - min)),
                                              TTGaugeViewSection(color: .warning, size: (max - warning) / (max - min))]
        
        return section
    }
    
    let angle: Double = 260.0
    
    let gaugeDescription = "Temp"
    
    var body: some View {
        
        //Text(String(settings.maxTemp))
        
            //Text(temp)
            
        TTGaugeView(angle: angle, sections: setGauge(min: settings.minTemp, max: settings.maxTemp, caution: settings.cautionTemp, warning: settings.warningTemp), settings: gaugeSettings, value: ((rawTemp - settings.minTemp) / (settings.maxTemp - settings.minTemp)), valueDescription: valueDescription, gaugeDescription: gaugeDescription)
            
    }
    
    //converts only if settings call for metric units
    func convertFtoC(input: Double) -> Double {
        if modelData.importedSettings.metricUnits {
            return (input - 32) * (5 / 9) //converts to C if true
        }
        return input
    }
}


struct GaugeView_Previews: PreviewProvider {
    static var importedSettings = ModelData().importedSettings
    
    static var previews: some View {
        GaugeView(rawTemp: 50, settings: importedSettings)
    }
}
