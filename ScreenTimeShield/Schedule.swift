//
//  Schedule.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import Foundation
import DeviceActivity

extension DeviceActivityName {
  static let daily = Self("daily")
}

class Schedule {
  static public func setSchedule(start: Date, end: Date) {
    let schedule = DeviceActivitySchedule(intervalStart: components(from: start),
                                          intervalEnd: components(from: end),
                                          repeats: true)
    
    do {
      try DeviceActivityCenter().startMonitoring(.daily, during: schedule)
    } catch {
      print("Error setting schedule: \(error)")
    }
  }

  static func components(from date: Date) -> DateComponents {
    Calendar.current.dateComponents([.hour, .minute], from: date)
  }
}
