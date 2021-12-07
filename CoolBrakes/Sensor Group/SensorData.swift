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

struct SensorStatus {
    var status: [Int] = [0, 0, 0, 0, 0, 0]
    var lf: Int = 0
    var rf: Int = 0
    var lr: Int = 0
    var rr: Int = 0
    var lc: Int = 0
    var rc: Int = 0
}
