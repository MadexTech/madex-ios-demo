//
//  DeviceInfoViewController.swift
//  MadexDemoApp
//
//  Created by perpointt on 30.08.2023.
//

import Foundation
import UIKit
import MadexSDK
import AppTrackingTransparency
import AdSupport
import WebKit

class DeviceInfoViewController:UIViewController {
    @IBOutlet weak var sdkVersion: UILabel!
    @IBOutlet weak var systemVersion: UILabel!
    @IBOutlet weak var deviceModel: UILabel!
    @IBOutlet weak var idfa: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var userAgent: UILabel!
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        sdkVersion.text = Madex.sdkVersion
        systemVersion.text = UIDevice.current.systemVersion
        deviceModel.text = UIDevice.modelName
        idfa.text = "Undefined"
        uuid.text = UIDevice.current.identifierForVendor?.uuidString ?? "Undefined"
        userAgent.text = "Undefined"
        setUserAgent()
        
        if #available(iOS 14, *) {
            let description = Bundle.main.infoDictionary?["NSUserTrackingUsageDescription"] as? String
            if (description == nil) {
                setIdfa()
            } else {
                ATTrackingManager.requestTrackingAuthorization { [self] status in
                    setIdfa()
                }
            }
        } else {
            setIdfa()
        }
    }
    
    func setUserAgent() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        if let webView = self.webView {
            webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (result, error) in
                if let unwrappedUserAgent = result as? String {
                    DispatchQueue.main.async { [self] in
                        userAgent.text = unwrappedUserAgent
                    }
                }
            })
        }
    }
    
    func setIdfa() {
        let value = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        DispatchQueue.main.async { [self] in
            idfa.text = value
        }
    }
    
    
    @IBAction func copyInfo(_ sender: UIButton) {
        switch(sender.tag) {
        case 0:
            UIPasteboard.general.string = sdkVersion.text
            break;
        case 1:
            UIPasteboard.general.string = systemVersion.text
            break;
        case 2:
            UIPasteboard.general.string = deviceModel.text
            break;
        case 3:
            UIPasteboard.general.string = idfa.text
            break;
        case 4:
            UIPasteboard.general.string = uuid.text
            break;
        case 5:
            UIPasteboard.general.string = userAgent.text
            break;
        default:
            break;
        }
        showToast("Copied!")
    }
}
