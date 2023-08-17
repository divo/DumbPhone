//
//  ScreenTimeShieldApp.swift
//  ScreenTimeShield
//
//  Created by Steven Diviney on 17/08/2023.
//

import SwiftUI
import FamilyControls

@main
struct ScreenTimeShieldApp: App {
  
  @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
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
