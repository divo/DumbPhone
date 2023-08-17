//
//  ContentView.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
  @State private var isShowingRestrict = false
  
  @EnvironmentObject var model: Model
  
  var body: some View {
    VStack {
      Button("Select apps to restrict") {
        isShowingRestrict = true
      }.familyActivityPicker(isPresented: $isShowingRestrict, selection: $model.selectionToRestrict)
      
    }.onChange(of: model.selectionToRestrict) { newValue in
      model.setRestrictions()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Model())
  }
}
