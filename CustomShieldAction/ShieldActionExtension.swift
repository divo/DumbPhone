//
//  ShieldActionExtension.swift
//  CustomShieldAction
//
//  Created by Steven Diviney on 17/08/2023.
//

import ManagedSettings
          
// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
          print("Primary")
//          ManagedSettingsStore().shield.applications = nil // How to remove the block forever
          completionHandler(.close)
        case .secondaryButtonPressed:
          completionHandler(.close)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
      // Handle the action as needed.
      switch action {
      case .primaryButtonPressed:
        print("Primary")
//          ManagedSettingsStore().shield.applications = nil // How to remove the block forever
        completionHandler(.close)
      case .secondaryButtonPressed:
        completionHandler(.close)
      @unknown default:
          fatalError()
      }
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
      // Handle the action as needed.
      switch action {
      case .primaryButtonPressed:
        print("Primary")
//          ManagedSettingsStore().shield.applications = nil // How to remove the block forever
        completionHandler(.close)
      case .secondaryButtonPressed:
        completionHandler(.close)
      @unknown default:
          fatalError()
      }
    }
}
