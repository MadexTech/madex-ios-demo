//
//  ConsentManagerViewController.swift
//  MadexDemoApp
//
//  Created by perpointt on 29.08.2023.
//

import Foundation
import UIKit
import MadexConsentManager
import MadexSDK

class ConsentManagerViewController:UIViewController {
    @IBOutlet weak var eventsLabel: UILabel!
    
    var storage:UserDefaults?
    
    override func viewDidLoad() {
        storage = UserDefaults(suiteName: "Demo app")
        ConsentManager.enableLog(true)
        ConsentManager.setDelegate(self)
        
        if let storage = self.storage {
            ConsentManager.setCustomStorage(storage)
        }
        
        addLog("Consent window initialized.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ConsentManager.registerCustomVendor { builder in
            let _ = builder
                .appendPolicyURL("https://madex.world/privacy-policy")
                .appendBundle("sspnet.tech.app")
                .appendName("Madex Demo App")
        }
    }
    
    @IBAction func showGDPRwindow(_ sender: Any) {
        clearStorage()
        
        ConsentManager.registerCustomVendor { builder in
            let _ = builder.appendGDPR(true)
        }
        
        ConsentManager.loadManager()
    }
    @IBAction func showNoGDPRwindow(_ sender: Any) {
        clearStorage()
        
        ConsentManager.registerCustomVendor { builder in
            let _ = builder.appendGDPR(false)
        }
        
        ConsentManager.loadManager()
    }
    
    @IBAction func clearLog(_ sender: Any) {
        eventsLabel.text = "* Consent window initialized."
    }
    
    func addLog(_ message:String) {
        let text = eventsLabel.text ?? ""
        eventsLabel.text = "\(text)\(text.isEmpty ? "" : "\n")* \(message)"
    }
    
    func clearStorage() {
        storage?.removeObject(forKey: "consentAlreadyAsked")
        storage?.removeObject(forKey: "hasConsent")
    }
}

extension ConsentManagerViewController:ConsentDelegate {
    func onConsentManagerLoaded() {
        addLog("onConsentManagerLoaded: Consent window ready to show.")
        ConsentManager.showConsentWindow(self)
    }
    
    func onConsentManagerLoadFailed(_ error: String) {
        addLog("onConsentManagerLoadFailed: Consent window did not load. \(error).")
    }
    
    func onConsentWindowShown() {
        addLog("onConsentWindowShown: Consent window shown.")
    }
    
    func onConsentManagerShownFailed(_ error: String) {
        addLog("onConsentManagerShownFailed: Consent window did not show. \(error).")
    }
    
    func onConsentWindowClosed(_ hasConsent: Bool) {
        addLog("onConsentWindowClosed: User consent \(hasConsent ? "" : "not") received.")
        Madex.setUserConsent(hasConsent)
    }
}
