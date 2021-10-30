//
//  Gauge.swift
//  BrakeSensor
//
//  Created by James Ford on 9/5/21.
//

import Foundation
import SwiftUI

struct Settings: Hashable, Codable {
    
    var minTemp: Double
    var cautionTemp: Double
    var warningTemp: Double
    var maxTemp: Double
    var axles: Int
    var units: String
    var minObservedTemp: [Double]
    var maxObservedTemp: [Double]
    var avgObservedTemp: [Double]
    


}
