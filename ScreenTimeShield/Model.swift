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
  
  @Published var selectionToRestrict: FamilyActivitySelection = FamilyActivitySelection()
  
  class var shared: Model {
    return _model
  }
}
