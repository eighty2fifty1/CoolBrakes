//
//  RepeaterUUID.swift
//  BrakeSensor
//
//  Created by James Ford on 9/11/21.
//

import Foundation
import CoreBluetooth

struct RepeaterUUID {
    static let str_repeaterServiceUUID = "00001818-0000-1000-8000-00805f9b34fb"
    
    static let str_repeaterCharUUID = "00002A6E-0000-1000-8000-00805f9b34fb"
    
    static let str_repeaterMsgSvcUUID = "0000181C-0000-1000-8000-00805f9b34fb"
    
    static let str_repeaterMsgCharUUID = "00002B25-0000-1000-8000-00805f9b34fb"
    
    static let repeaterTempSvcUUID = CBUUID(string: str_repeaterServiceUUID)
    static let repeaterTempCharUUID = CBUUID(string: str_repeaterCharUUID)
    static let repeaterMsgSvcUUID = CBUUID(string: str_repeaterMsgSvcUUID)
    static let repeaterMsgCharUUID = CBUUID(string: str_repeaterMsgCharUUID)
    
    //from android app.  not sure if needed yet
    // public static final UUID CONFIG_DESCRIPTOR = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb")
}
