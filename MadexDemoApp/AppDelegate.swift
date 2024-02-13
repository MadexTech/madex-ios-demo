//
//  AppDelegate.swift
//  MadexDemoApp
//
//  Created by perpointt on 23.11.2023.
//

import UIKit
import MadexSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Madex.setCustomParams("appStoreAppID", EnvironmentVariables.appStoreAppID)
        Madex.enableDebug(true)
        Madex.initialize(publisherID: EnvironmentVariables.publisherID) { error in
            
        }
        
        return true
    }
}

