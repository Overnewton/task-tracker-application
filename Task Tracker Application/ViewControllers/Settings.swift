//
//  Settings.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 24/7/2026.
//

import UIKit

class Settings: UIViewController {
    
    override func loadView() {
        view = UIView()
        //set background colour to match with the background colour that is stored in the global state
        view.backgroundColor = GlobalState.shared.backgroundColour.UIColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
