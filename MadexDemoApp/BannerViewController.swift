//
//  BannerViewController.swift
//  Example
//
//  Created by perpointt on 29.08.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import MadexSDK

class BannerViewController:UIViewController {
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var mediationPopupButton: UIButton!
    
    var placementName:String = EnvironmentVariables.madexBannerUnitID
    
    override func viewDidLoad() {
        if #available(iOS 14.0, *) {
            let optionClosure = { [self](action:UIAction) in
                mediationPopupButton.setTitle(action.title, for: .normal)
                selectPlacementName(action.title)
                addLog("Ad will be loaded from \(action.title).")
            }
            
            mediationPopupButton.setTitle(MediationNetworks.madex, for: .normal)
            setMediationPopup(mediationPopupButton, optionClosure)
        } else {
            mediationPopupButton.isEnabled = false
            mediationPopupButton.setTitle("Avaliable from iOS 14.0", for: .normal)
            
            addLog("Mediation avaliable only from iOS 14.0.")
        }
        
        Madex.setBannerDelegate(self)
        
        addLog("Madex \(Madex.sdkVersion) initialized.")
    }
    
    @IBAction func loadAd(_ sender: Any) {
        if (Madex.canLoadAd(Madex.BANNER, placementName)) {
            addLog("Ad start to load.")
            Madex.setBannerCustomSettings { settings in
                let _ = settings
                    .updateShowCloseButton(true)
                    .updateRefreshIntervalSeconds(10)
            }
           
            Madex.loadAd(Madex.BANNER, placementName)
        } else {
            addLog("SDK can't start load ad.")
        }
    }
    
    @IBAction func showAd(_ sender: Any) {
        if (Madex.isAdLoaded(Madex.BANNER, placementName)) {
            Madex.showAd(
                adType: Madex.BANNER,
                placementName: placementName,
                rootViewController: self
            )
        } else {
            addLog("Ad is not loaded yet")
        }
    }
    
    @IBAction func destroyAd(_ sender: Any) {
        Madex.destroyAd(Madex.BANNER, placementName)
        addLog("Ad was destroyed.")
    }
    
    @IBAction func clearLog(_ sender: Any) {
        eventsLabel.text = "* Madex \(Madex.sdkVersion) initialized."
    }
    
    func addLog(_ message:String) {
        let text = eventsLabel.text ?? ""
        eventsLabel.text = "\(text)\(text.isEmpty ? "" : "\n")* \(message)"
    }
    
    func selectPlacementName(_ network:String) {
        switch(network) {
        case MediationNetworks.madex:
            placementName = EnvironmentVariables.madexBannerUnitID
            break
        default:
            break
        }
    }
}


extension BannerViewController:BannerDelegate {
    
    func onBannerLoaded(_ adPayload:AdPayload) {
        addLog("onBannerLoaded: Ad loaded and ready to show.")
    }
    
    func onBannerLoadFailed(_ adPayload:AdPayload, _ error: AdException) {
        addLog("onBannerLoadFailed: Ad was not loaded. \(error.localizedDescription) (\(error.caused)).")
    }
    
    func onBannerShown(_ adPayload:AdPayload) {
        addLog("onBannerShown: Ad shown.")
    }
    
    func onBannerShowFailed(_ adPayload:AdPayload, _ error: AdException) {
        addLog("onBannerShowFailed: Ad was not shown. \(error.localizedDescription) (\(error.caused)).")
    }
    
    func onBannerClosed(_ adPayload:AdPayload) {
        addLog("onBannerClosed: Ad closed.")
    }
    
    func onBannerImpression(_ adPayload: AdPayload) {
        addLog("onBannerImpression: Banner get impression.")
    }
}
