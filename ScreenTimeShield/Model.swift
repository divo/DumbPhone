//
//  Model.swift
//  DumbPhone
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
  private static let userDefaultsSuite = "group.halfspud.DumbPhone"

//  @AppStorage("inside_interval", store: UserDefaults(suiteName: Model.userDefaultsSuite)) var insideInterval: Bool = false
  
  @Published var selectionToRestrict: FamilyActivitySelection = FamilyActivitySelection()
  
  static let start: Date = Calendar.current.startOfDay(for: Date.now)
  static let end: Date = Date(timeInterval: 86399, since: Model.start)
  
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
