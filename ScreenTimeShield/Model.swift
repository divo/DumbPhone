//
//  Model.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import Foundation
import FamilyControls
import ManagedSettings

private let _model = Model()

class Model: ObservableObject {
  
  let store = ManagedSettingsStore()
  
  @Published var selectionToRestrict: FamilyActivitySelection = FamilyActivitySelection()
  
  class var shared: Model {
    return _model
  }
  
  func setRestrictions() {
    let applications = Model.shared.selectionToRestrict
    
    store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
    store.shield.applicationCategories = applications.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
  }
}
