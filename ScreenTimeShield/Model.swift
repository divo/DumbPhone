//
//  Model.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import SwiftUI

private let _model = Model()

class Model: ObservableObject {
  
  let store = ManagedSettingsStore()
  
  private let encoder = PropertyListEncoder()
  private let decoder = PropertyListDecoder()
  private let userDefaultsKey = "ScreenTimeSeletion"
  private static let userDefaultsSuite = "group.screentimeshield"

  @AppStorage("inside_interval", store: UserDefaults(suiteName: Model.userDefaultsSuite)) var insideInterval: Bool = false
  
  @Published var selectionToRestrict: FamilyActivitySelection = FamilyActivitySelection()
  @Published var start: Date = (UserDefaults(suiteName: Model.userDefaultsSuite)?.object(forKey: "start") as? Date) ??
    Calendar.current.startOfDay(for: Date.now) {
    didSet {
      UserDefaults(suiteName: Model.userDefaultsSuite)!.set(start, forKey: "start")
    }
  }
  
  @Published var end: Date = (UserDefaults(suiteName: Model.userDefaultsSuite)?.object(forKey: "end") as? Date) ??
    Calendar.current.startOfDay(for: Date.now) {
    didSet {
      UserDefaults(suiteName: Model.userDefaultsSuite)!.set(end, forKey: "end")
    }
  }
  
  class var shared: Model {
    return _model
  }
  
  func loadSelection() {
    self.selectionToRestrict = savedSelection() ?? FamilyActivitySelection()
  }
  
  private func savedSelection() -> FamilyActivitySelection? {
    let defaults = UserDefaults(suiteName: Model.userDefaultsSuite)!
    guard let data = defaults.data(forKey: userDefaultsKey) else { return nil }
    
    return try? decoder.decode(FamilyActivitySelection.self, from: data)
  }
  
  func saveSelection() {
    let defaults = UserDefaults(suiteName: Model.userDefaultsSuite)!
    let data = try? encoder.encode(selectionToRestrict)
    
    defaults.set(data, forKey: userDefaultsKey)
    defaults.synchronize()
  }
  
  func setRestrictions() {
    let applications = self.selectionToRestrict
    
    store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
    store.shield.applicationCategories = applications.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    store.shield.webDomains = applications.webDomainTokens.isEmpty ? nil : applications.webDomainTokens
  }
  
  func clearRestrictions() {
    store.shield.applications = nil
    store.shield.applicationCategories = nil
    store.shield.webDomains = nil
  }
  
  func isEmpty() -> Bool {
    return selectionToRestrict.applicationTokens.isEmpty
      && selectionToRestrict.categoryTokens.isEmpty
      && selectionToRestrict.webDomainTokens.isEmpty
  }
  
  func activityEvent() -> DeviceActivityEvent {
    let applications = Model.shared.selectionToRestrict
    return DeviceActivityEvent(
      applications: applications.applicationTokens,
      categories: applications.categoryTokens,
      webDomains: applications.webDomainTokens,
      threshold: DateComponents(minute: 0)
    )
  }
}
