//
//  DSVExtension.swift
//  CoolBrakes
//
//  Created by James Ford on 11/3/21.
//

import Foundation

extension DisplaySettingsView {
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
    
    var inputValidated: Bool {
        if isInputValidated() {
            return true
        }
        return false
    }
    
    func validateMin() -> Bool {
        if (minTemp ?? 0 < fmin(cautionTemp ?? 0, warningTemp ?? 0)) &&  (minTemp ?? 0 < fmin(maxTemp ?? 0, alertTemp ?? 0)){
            print("mintemp valid")
            return true
        }
        print("min invalid")
        return false
    }
    
    func validateCaution() -> Bool {
        if (minTemp ?? 0 < cautionTemp ?? 0) && (cautionTemp ?? 0 < fmin(warningTemp ?? 0, maxTemp ?? 0)) {
            print("cautiontemp valid")
            return true
        }
        print("caution invalid")
        return false
    }
    
    func validateWarning() -> Bool {
        if (fmax(minTemp ?? 0, cautionTemp ?? 0) < warningTemp ?? 0) && (warningTemp ?? 0 < maxTemp ?? 0) {
            print("warningtemp valid")
            return true
        }
        print("warning invalid")
        return false
    }
    
    func validateMax() -> Bool {
        if (maxTemp ?? 0 > fmax(minTemp ?? 0, cautionTemp ?? 0)) && (maxTemp ?? 0 > fmax(warningTemp ?? 0, alertTemp ?? 0)) {
            print("maxtemp valid")
            return true
        }
        print("max invalid")
        return false
    }
    
    func validateAlert() -> Bool {
        if (minTemp ?? 0 < alertTemp ?? 0) && (alertTemp ?? 0 < maxTemp ?? 0) {
            print("alerttemp valid")
            return true
        }
        print("alert invalid")
        return false
    }
    
    func isInputValidated() -> Bool
    {
        if !validateMin() || !validateCaution() || !validateWarning() || !validateMax() || !validateAlert() {
            print("input invalid")
            return false
        }
        print("input is validated")
        return true
        
    }
}
