//
//  Gauge.swift
//  BrakeSensor
//
//  Created by James Ford on 9/5/21.
//

// REMEMBER TO CLEAN BUILD FOLDER AFTER MODIFYING JSON

import Foundation
import SwiftUI

struct Settings: Hashable, Codable {
    //var id: UUID
    var minTemp: Double
    var cautionTemp: Double
    var warningTemp: Double
    var alertTemp: Double
    var maxTemp: Double
    var axles: Int
    var minObservedTemp: [Double]
    var maxObservedTemp: [Double]
    var avgObservedTemp: [Double]
    var metricUnits: Bool
    

    /*
    func convertFtoC(input: Double) -> Double {
        if metricUnits {
            return (input - 32) * (5 / 9) //converts to C if true
        }
        return input
    }
*/
}
