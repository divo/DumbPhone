//
//  DumbPhoneApp.swift
//  DumbPhone
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls

@main
struct DumbPhoneApp: App {
  
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  @StateObject var model = Model.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(model)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    Task {
      await requestFamilyControls()
    }
    
    return true
  }
  
  func requestFamilyControls() async {
    do {
      try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    } catch {
      print("Error requesting Family Controls: \(error)")
    }
  }
}
