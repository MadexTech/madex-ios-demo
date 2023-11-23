//
//  InterstitialViewController.swift
//  MadexDemoApp
//
//  Created by perpointt on 29.08.2023.
//

import Foundation
import UIKit
import MadexSDK

class InterstitialViewController:UIViewController {
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var mediationPopupButton: UIButton!
    
    var placementName:String = EnvironmentVariables.madexInterstitialUnitID
    
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
        
        Madex.setInterstitialDelegate(self)
        
        addLog("Madex \(Madex.sdkVersion) initialized.")
    }
    
    @IBAction func loadAd(_ sender: Any) {
        if (Madex.canLoadAd(Madex.INTERSTITIAL, placementName)) {
            addLog("Ad start to load.")
            Madex.loadAd(Madex.INTERSTITIAL, placementName)
        } else {
            addLog("SDK can't start load ad.")
        }
    }
    
    @IBAction func showAd(_ sender: Any) {
        if (Madex.isAdLoaded(Madex.INTERSTITIAL, placementName)) {
            Madex.showAd(
                adType: Madex.INTERSTITIAL,
                placementName: placementName,
                rootViewController: self
            )
        } else {
            addLog("Ad is not loaded yet")
        }
        
    }
    
    @IBAction func destroyAd(_ sender: Any) {
        Madex.destroyAd(Madex.INTERSTITIAL, placementName)
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
            placementName = EnvironmentVariables.madexInterstitialUnitID
            break
        case MediationNetworks.yandex:
            placementName = EnvironmentVariables.yandexInterstitialUnitID
            break
        case MediationNetworks.ironsource:
            placementName = EnvironmentVariables.ironsourceInterstitialUnitID
            break
        case MediationNetworks.mintegral:
            placementName = EnvironmentVariables.mintegralInterstitialUnitID
            break
        default:
            break
        }
    }
}



extension InterstitialViewController:InterstitialDelegate {
    func onInterstitialLoaded() {
        addLog("onInterstitialLoaded: Ad loaded and ready to show.")
    }
    
    func onInterstitialLoadFailed(_ error: AdException) {
        addLog("onInterstitialLoadFailed: Ad was not loaded. \(error.localizedDescription) (\(error.caused)).")
    }
    
    func onInterstitialShown() {
        addLog("onInterstitialShown: Ad shown.")
    }
    
    func onInterstitialShowFailed(_ error: AdException) {
        addLog("onInterstitialLoadFailed: Ad was not shown. \(error.localizedDescription) (\(error.caused)).")
    }
    
    func onInterstitialClosed() {
        addLog("onInterstitialClosed: Ad closed.")
    }
}
