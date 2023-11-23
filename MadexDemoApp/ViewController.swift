//
//  ViewController.swift
//  MadexDemoApp
//
//  Created by perpointt on 29.08.2023.
//

import Foundation
import UIKit
import MadexSDK

class ViewController:UITableViewController {
    @IBOutlet weak var sdkInfoLabel: UILabel!
    
    override func viewDidLoad() {
        let sdkVersion = Madex.sdkVersion
        
        sdkInfoLabel.text = "v\(sdkVersion)"
    }
}
