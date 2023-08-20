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

private let _model = Model()

class Model: ObservableObject {
  
  let store = ManagedSettingsStore()
  
  private let encoder = PropertyListEncoder()
  private let decoder = PropertyListDecoder()
  private let userDefaultsKey = "ScreenTimeSeletion"
  
  @Published var selectionToRestrict: FamilyActivitySelection = FamilyActivitySelection()
  
  class var shared: Model {
    return _model
  }
  
  func loadSelection() {
    self.selectionToRestrict = savedSelection() ?? FamilyActivitySelection()
  }
  
  private func savedSelection() -> FamilyActivitySelection? {
    let defaults = UserDefaults.standard
    guard let data = defaults.data(forKey: userDefaultsKey) else { return nil }
    
    return try? decoder.decode(FamilyActivitySelection.self, from: data)
  }
  
  func saveSelection() {
    let defaults = UserDefaults.standard
    
    defaults.set(try? encoder.encode(selectionToRestrict), forKey: userDefaultsKey)
  }
  
  func setRestrictions() {
    let applications = Model.shared.selectionToRestrict
    
    store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
    store.shield.applicationCategories = applications.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    store.shield.webDomains = applications.webDomainTokens.isEmpty ? nil : applications.webDomainTokens
  }
}
