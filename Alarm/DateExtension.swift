//
//  DateExtension.swift
//  Alarm
//
//  Created by Bobba Kadush on 5/7/19.
//  Copyright © 2019 Bobba Kadush. All rights reserved.
//

import Foundation

extension Date {
    
    func toStringWith(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
}
