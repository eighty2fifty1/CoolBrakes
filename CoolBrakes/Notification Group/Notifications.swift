//
//  Notifications.swift
//  CoolBrakes
//
//  Created by James Ford on 10/27/21.
//
//  This class manages all the notifications
import Foundation
import UserNotifications

class Notifications: ObservableObject {
    
    let position: [String] = ["", "Left Front", "Right Front", "Left Rear", "Right Rear", "Left Center", "Right Center"] //must have empty value in 0 position to avoid off-by-one error
    
    //asks for notification permission
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success {
                print("Notifications authorized")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //sensor overheat
    func overtempAlert(positIndex: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Brake Overheat: \(position[positIndex])"
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("overtemp alert sent: \(position[positIndex])")
    }
    
    //low battery
    func lowBatteryAlert(positIndex: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Low Battery: \(position[positIndex])"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("low battery alert sent")
    }
    
    //sensor disconnected
    func sensorDisconnectAlert(positIndex: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Sensor Disconnected: \(position[positIndex])"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("disconnect alert sent")
    }
    
    func repeaterConnectAlert() {
        let content = UNMutableNotificationContent()
        content.title = "CoolBrakes is connected"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("connect alert sent")
    }
    
    //repeater disconnect
    func repeaterDisconnectAlert() {
        let content = UNMutableNotificationContent()
        content.title = "CoolBrakes Disconnected"
        content.body = "Attempting to reconnect.  Ensure the device is powered on and in range"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("disconnect alert sent")
    }
}
