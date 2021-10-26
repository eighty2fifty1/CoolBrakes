//
//  CoreBLEDelegate.swift
//  BrakeSensor
//
//  Created by James Ford on 9/7/21.
//

import Foundation
import CoreBluetooth
import OSLog
import CoreData

struct Peripheral: Identifiable {
    let id: Int
    let name:  String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate{

    
    @Published var centralManager: CBCentralManager!
    @Published var isSwitchedOn = false
    private var bleRepeater: CBPeripheral!
    @Published var dataChar: CBCharacteristic!
    @Published var msgChar: CBCharacteristic!
    @Published var tempMsg: String!
    @Published var statusMsg: String!
    
    @Published var LF = SensorData()
    @Published var RF = SensorData()
    @Published var LR = SensorData()
    @Published var RR = SensorData()
    @Published var LC = SensorData()
    @Published var RC = SensorData()
    
    private var incomingStringArray: [String] = []
    @Published var incomingIntArray: [Int] = []
    
        
    let customLog = Logger()
    
    override init() {
        
        super.init()
            
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
            startScanning()
        } else {
            isSwitchedOn = false
        }
    }
    
    func startScanning() -> Void {
        centralManager.scanForPeripherals(withServices: [RepeaterUUID.repeaterTempSvcUUID, RepeaterUUID.repeaterMsgSvcUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        bleRepeater = peripheral
        bleRepeater.delegate = self
        centralManager?.stopScan()
        
        customLog.notice("Found the device: \(self.bleRepeater.name!)")
        centralManager?.connect(bleRepeater!, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        bleRepeater.discoverServices([RepeaterUUID.repeaterMsgSvcUUID, RepeaterUUID.repeaterTempSvcUUID])
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if ((error) != nil){
            customLog.error("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {peripheral.discoverCharacteristics([RepeaterUUID.repeaterMsgCharUUID, RepeaterUUID.repeaterTempCharUUID], for: service)
        }
        
        customLog.notice("Discovered services: \(services)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        customLog.notice("Found \(characteristics.count) characteristics")
        
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(RepeaterUUID.repeaterMsgCharUUID) {
                msgChar = characteristic
                peripheral.setNotifyValue(true, for: msgChar)
                
            }
            
            else if characteristic.uuid.isEqual(RepeaterUUID.repeaterTempCharUUID) {
                dataChar = characteristic
                peripheral.setNotifyValue(true, for: dataChar)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if let error = error {
            customLog.error("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristicData = characteristic.value,
              let stringFromData = String(data: characteristicData, encoding: .utf8) else {
            return
        }
        
        //customLog.notice("Received \(characteristicData.count) bytes from \(characteristic.uuid) characteristic: \(stringFromData)")
        
        if characteristic.uuid == RepeaterUUID.repeaterMsgCharUUID {
            statusMsg = stringFromData
            incomingStringArray = statusMsg.components(separatedBy: "i")
            incomingIntArray = incomingStringArray.map{Int($0)!}
            parseStatusMsgData(incoming: self.incomingIntArray)
            //customLog.notice("Status: \(self.statusMsg)")
            
            
        }
        else if characteristic.uuid == RepeaterUUID.repeaterTempCharUUID {
            tempMsg = stringFromData
            incomingStringArray = tempMsg.components(separatedBy: "i")
            incomingIntArray = incomingStringArray.map{Int($0)!}
            parseIncoming(incoming: self.incomingIntArray)
            //customLog.notice("Temp: \(self.tempMsg)")
            
            //         incoming key
            //incoming[0]: position 1-6 -> LF, RF, LR, RR, LC, RC
            //incoming[1]: temperature Integer
            //incoming[2]: battery pct Integer
            
        }
    }
    
    func parseIncoming(incoming: [Int]) {
        //compareMaxMin(posit: incoming[0] - 1, temp: incoming[1])
        
        switch incoming[0] {
        case 1:
            LF.posit = incoming[0]
            LF.temp = incoming[1]
            LF.batt = incoming[2]
            
        case 2:
            RF.posit = incoming[0]
            RF.temp = incoming[1]
            RF.batt = incoming[2]
        case 3:
            LR.posit = incoming[0]
            LR.temp = incoming[1]
            LR.batt = incoming[2]
        case 4:
            RR.posit = incoming[0]
            RR.temp = incoming[1]
            RR.batt = incoming[2]
        case 5:
            LC.posit = incoming[0]
            LC.temp = incoming[1]
            LC.batt = incoming[2]
        case 6:
            RC.posit = incoming[0]
            RC.temp = incoming[1]
            RC.batt = incoming[2]
            
        default:
            return
        }
    

    }
    
    func parseStatusMsgData(incoming: [Int]) {
        
        //incoming status msg key
        // <
        // Int[0 - 5], sensor status 0: not connected, 1: normal operation, 2: timed out for unknown reason, 3: sleeping (commanded or inactivity)
        // Int[6] sensors connected

    }
    
    func sendStatusMsg(msg: String) {
        let data = Data(msg.utf8)
        bleRepeater.writeValue(data, for: msgChar, type: .withoutResponse)
        print(msg)
        
        //status msg key
        // Send:
        // <
        // Int[0], reset message.  1: resets client via software, 2: resets client via hardware (power chop?), 3: resets server via software
        // Int[1], sensors expected.  axles * 2
        // Int[2], mac addr request. 1: requests.  not sure if this works yet or if its necessary to begin with
        // Int[3], force scan. 1 requests it.  again, not sure if i set this up or not
        // Int[4]  sleep sensor. 1-6 for which sensor to force to sleep.  13 sleeps all.  not implemented?
        // >
    }
}
/*
extension BLEManager {
    //@EnvironmentObject var modelData: ModelData //TODO: this fuckin thing

    func compareMaxMin(posit: Int, temp: Int) {
        if self.modelData.importedSettings.maxObservedTemp[posit] < Double(temp) {
            self.modelData.importedSettings.maxObservedTemp[posit] = Double(temp)
        }
        
        if self.modelData.importedSettings.minObservedTemp[posit] > Double(temp) {
            self.modelData.importedSettings.minObservedTemp[posit] = Double(temp)
        }
    }
}
*/
