//
//  AlarmController.swift
//  Alarm
//
//  Created by Bobba Kadush on 5/6/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class{
    
}

extension AlarmScheduler{
    func scheduleUserNotifications(for alarm: Alarm){
        let content = UNMutableNotificationContent()
        content.title = "ALARM!"
        let date = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        print(alarm.fireDate.toStringWith(dateStyle: .medium, timeStyle: .medium))
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("unable to schedule local notification request: \(error) : \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        
    }
}

class AlarmController: AlarmScheduler{
    static let shared = AlarmController()
    
    var alarms = [Alarm]()
    
    private init(){
        alarms = loadFromPersistence()
    }
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool){
        let alarm = Alarm(name: name, enabled: enabled, fireDate: fireDate)
        alarms.append(alarm)
        scheduleUserNotifications(for: alarm)
        saveToPersistence()
    }
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistence()
    }
    func delete(alarm: Alarm){
        guard let deleteAlarm = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: deleteAlarm)
        cancelUserNotifications(for: alarm)
        saveToPersistence()
    }
    
//    var mockAlarms: [Alarm] {
//        let goToClass = Alarm(name: "Alarm1", fireDate: Date(timeIntervalSinceNow: 60 * 60 * 2))
//        let runaway = Alarm(name: "Alarm2", fireDate: Date(timeIntervalSinceNow: 60 * 60 * 4))
//        let sleep = Alarm(name: "Alarm3", fireDate: Date(timeIntervalSinceNow: 60 * 60 * 6))
//        return [goToClass,runaway,sleep]
//    }
    func toggleEnabled(for alarm: Alarm){
        alarm.enabled = !alarm.enabled
        if alarm.enabled == true {
            scheduleUserNotifications(for: alarm)
        }else{
            cancelUserNotifications(for: alarm)
        }
        saveToPersistence()
    }
    
    private func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarm.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        
        return fullURL
        
    }
    
    private func saveToPersistence() {
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        }catch {
            print(error)
        }
    }
    
    private func loadFromPersistence() ->[Alarm] {
        let decoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: fileURL())
            let alarms = try decoder.decode([Alarm].self, from: data)
            return alarms
            
        }catch{
            print(error)
        }
        return []
    }
    
}

