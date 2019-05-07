//
//  Alarm.swift
//  Alarm
//
//  Created by Bobba Kadush on 5/6/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import Foundation

class Alarm: Codable{
    
    var name: String
    var enabled: Bool
    var fireDate: Date
    var uuid: String
    var fireTimeAsString: String {
            return fireDate.toStringWith(dateStyle: .none, timeStyle: .short)
    }
    
    init(name: String, enabled: Bool = true, fireDate: Date, uuid: String = UUID().uuidString) {
        self.name = name
        self.enabled = enabled
        self.fireDate = fireDate
        self.uuid = uuid
    }
}

extension Alarm: Equatable{
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.name == rhs.name && lhs.enabled == rhs.enabled && lhs.fireDate == rhs.fireDate && lhs.uuid == rhs.uuid
    }
}

