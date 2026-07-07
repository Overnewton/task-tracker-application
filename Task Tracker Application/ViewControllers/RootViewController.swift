//
//  ViewController.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 18/6/2026.
//

import UIKit

class RootViewController: UIViewController {
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = GlobalState.shared.backgroundColour.UIColor()
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
