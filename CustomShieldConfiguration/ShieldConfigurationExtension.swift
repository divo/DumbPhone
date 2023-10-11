//
//  ShieldConfigurationExtension.swift
//  CustomShieldConfiguration
//
//  Created by Steven Diviney on 17/08/2023.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
      customShieldConfiguration()
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
      customShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
      customShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
      customShieldConfiguration()
    }
  
  func customShieldConfiguration() -> ShieldConfiguration {
    let primaryLabel = ShieldConfiguration.Label(text: "Unplug", color: UIColor.lightGray)
    let subtitleLabel = ShieldConfiguration.Label(text: "App limits reached", color: UIColor.lightGray)
    
    let primaryButton = ShieldConfiguration.Label(text: "Close", color: .black)
    let secondaryButton = ShieldConfiguration.Label(text: "", color: UIColor.lightGray)
    
    return ShieldConfiguration(backgroundBlurStyle: UIBlurEffect.Style.systemMaterialDark,
                               backgroundColor: UIColor.black,
                               icon: UIImage(named: "unplug")?.withTintColor(.lightGray),
                               title: primaryLabel,
                               subtitle: subtitleLabel,
                               primaryButtonLabel: primaryButton,
                               primaryButtonBackgroundColor: Style.primaryUIColor,
                               secondaryButtonLabel: secondaryButton)
  }
}
