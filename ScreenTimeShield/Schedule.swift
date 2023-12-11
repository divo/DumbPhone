//
//  Schedule.swift
//  DumbPhone
//
//  Created by Steven Diviney on 17/08/2023.
//

import Foundation
import DeviceActivity

extension DeviceActivityName {
  static let daily = Self("daily")
}

class Schedule {
  static public func setSchedule(start: Date, end: Date, event: DeviceActivityEvent) {
    let schedule = DeviceActivitySchedule(intervalStart: components(from: start),
                                          intervalEnd: components(from: end),
                                          repeats: true)
    
    
    let center = DeviceActivityCenter()
    center.stopMonitoring()

    let eventName = DeviceActivityEvent.Name("DumbPhone.Event")

    do {
      try center.startMonitoring(
        .daily,
        during: schedule,
        events: [
          eventName: event
        ]
      )
      try DeviceActivityCenter().startMonitoring(.daily, during: schedule)
    } catch {
      print("Error setting schedule: \(error)")
    }
  }

  static func components(from date: Date) -> DateComponents {
    Calendar.current.dateComponents([.hour, .minute], from: date)
  }
}
