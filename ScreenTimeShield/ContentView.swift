//
//  ContentView.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls
import Foundation

struct ContentView: View {
  @State private var isShowingRestrict = false
  
  @EnvironmentObject var model: Model
  
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          Text("Unskippable app limits").padding(.horizontal)
          Spacer()
        }
        
        if model.selectionToRestrict.applicationTokens.count != 0 {
          Text("You have restricted \(model.selectionToRestrict.applicationTokens.count) apps").padding(20)
//          Text(model.selectionToRestrict.applications.first?.localizedDisplayName ?? "")
        }
        
        VStack {
          DatePicker("Schedule start", selection: $model.start, displayedComponents: .hourAndMinute)
          DatePicker("Schedule End", selection: $model.end, displayedComponents: .hourAndMinute)
        }.padding(20)
        Button("Select apps to restrict") {
          isShowingRestrict = true
        }.familyActivityPicker(isPresented: $isShowingRestrict, selection: $model.selectionToRestrict)
          .padding(20)
          .foregroundColor(Style.primaryColor)
        Spacer()
        
      }.onChange(of: model.selectionToRestrict) { newValue in
        model.saveSelection()
        Schedule.setSchedule(start: model.start, end: model.end, event: model.activityEvent())
      }.onChange(of: model.start) { newValue in
        if !model.isEmpty() {
          Schedule.setSchedule(start: model.start, end: model.end, event: model.activityEvent())
        }
      }.onChange(of: model.end) { newValue in
        if !model.isEmpty() {
          Schedule.setSchedule(start: model.start, end: model.end, event: model.activityEvent())
        }
      }.navigationTitle("Unplug ∎")
        .navigationBarTitleDisplayMode(.large)
    }.onAppear {
      model.loadSelection()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Model())
  }
}
