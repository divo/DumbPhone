//
//  ContentView.swift
//  DumbPhone
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls
import Foundation

struct ContentView: View {
  @State private var isShowingRestrict = false
  
  @EnvironmentObject var model: Model
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "AvenirNextCondensed-Bold", size: 28)!]
  }
 
  var body: some View {
    NavigationView {
      VStack {
        HStack {
          Text("Permanent App Blocks").padding(.horizontal)
          Spacer()
        }
        
        if model.selectionToRestrict.applicationTokens.count != 0 {
          Text("You have restricted \(model.selectionToRestrict.applicationTokens.count) apps and \(model.selectionToRestrict.webDomainTokens.count) websites").padding(20)
//          Text(model.selectionToRestrict.applications.first?.localizedDisplayName ?? "")
        }
        VStack {
          Spacer()
          Button("Select apps to block") {
            isShowingRestrict = true
          }.disabled(model.insideInterval)
            .familyActivityPicker(isPresented: $isShowingRestrict, selection: $model.selectionToRestrict)
            .padding(20)
            .controlSize(.large)
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(Style.primaryColor)
          HStack {
            Image(systemName: "exclamationmark.triangle").foregroundColor(Color(uiColor: .systemPink))
            Text("Apps cannot be removed from block")
          }.padding(.bottom, 40)
        }
          
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
      }.navigationTitle("Dumb Phone μ")
        .navigationBarTitleDisplayMode(.large)
    }.onAppear {
      model.loadSelection()
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(Model())
  }
}
