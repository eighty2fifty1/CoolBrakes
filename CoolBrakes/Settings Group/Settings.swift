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
    
    var minPrompt: String {
        if validateMin() {
           return ""
        }
        return "Must be below Caution, Warning, and Max"
    }
    
    var cautionPrompt: String {
        if validateCaution() {
            return ""
        }
        return "Must be above Min and below Warning and Max"
    }
    
    var warningPrompt: String {
        if validateWarning() {
            return ""
        }
        return "Must be above Min and Caution, and below Max"
    }
    
    var maxPrompt: String {
        if validateMax() {
            return ""
        }
        return "Must be above Min, Caution, and Warning"
    }
    
    var alertPrompt: String {
        if validateAlert() {
            return ""
        }
        return "Must be between Min and Max"
    }
    
    func validateMin() -> Bool {
        if minTemp < fmin(cautionTemp, warningTemp) &&  minTemp < fmin(maxTemp, alertTemp){
            return true
        }
        return false
    }
    
    func validateCaution() -> Bool {
        if minTemp < cautionTemp && cautionTemp < fmin(warningTemp, maxTemp) {
            return true
        }
        return false
    }
    
    func validateWarning() -> Bool {
        if fmax(minTemp, cautionTemp) < warningTemp && warningTemp < maxTemp {
            return true
        }
        return false
    }
    
    func validateMax() -> Bool {
        if maxTemp > fmax(minTemp, cautionTemp) && maxTemp > fmax(warningTemp, alertTemp) {
            return true
        }
        return false
    }
    
    func validateAlert() -> Bool {
        if minTemp < alertTemp && alertTemp < maxTemp {
            return true
        }
        return false
    }
    /*
    func convertFtoC(input: Double) -> Double {
        if metricUnits {
            return (input - 32) * (5 / 9) //converts to C if true
        }
        return input
    }
*/
}
