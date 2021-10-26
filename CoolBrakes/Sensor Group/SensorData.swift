//
//  SensorData.swift
//  BrakeSensor
//
//  Created by James Ford on 9/7/21.
//
//  Holds the data from the individual sensors

import Foundation

struct SensorData {
    var temp: Int = 0
    var batt: Int = 0 //debug: Int.random(in: 24...26) //change back to 0 for production
    var posit: Int = 0
}
