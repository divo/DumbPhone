//
//  ContentView.swift
//  DumbPhone
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls
import Foundation
import AlertToast

struct ContentView: View {
  @State private var isShowingRestrict = false
  @EnvironmentObject var model: Model
  @State var showToast: Bool = false
  
  
  var body: some View {
    NavigationView {
      ZStack {
        Style.backgroundColor.edgesIgnoringSafeArea(.all)
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
            }.familyActivityPicker(isPresented: $isShowingRestrict, selection: $model.selectionToRestrict)
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
        }
        
      }.toast(isPresenting: $showToast, alert: {
        AlertToast(displayMode: .alert, type: .error(Style.errorColor), title: "Cannot remove apps from block")
      })
      .onChange(of: model.selectionToRestrict) { newValue in
        if model.validateRestriction() {
          model.saveSelection()
          Schedule.setSchedule(start: Model.start, end: Model.end, event: model.activityEvent())
        } else {
          // TODO: Show warning
          print("Cannot remove apps from restrictions")
          showToast = true
          model.loadSelection()
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
