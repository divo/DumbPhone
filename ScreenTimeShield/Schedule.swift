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

// Schdule is 24 hours a day
let schedule = DeviceActivitySchedule(
  intervalStart: DateComponents(hour: 0, minute: 0 ),
  intervalEnd: DateComponents(hour: 23, minute: 59),
  repeats: true
)

class Schedule {
  static public func setSchedule() {
    do {
      try DeviceActivityCenter().startMonitoring(.daily, during: schedule)
    } catch {
      print("Error setting schedule: \(error)")
    }
  }
}
