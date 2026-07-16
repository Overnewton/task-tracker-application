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
        //set background colour to match with the background colour that is stored in the global state
        view.backgroundColor = GlobalState.shared.backgroundColour.UIColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //define UI
        let buttonAction = UIAction(title: "Next View") { _ in
            let next = TaskAdding()
            GlobalState.switchRoot(to: next)
        }
        
        
        let myButton = UIButton(type: .system, primaryAction: buttonAction)
        
        myButton.backgroundColor = .systemBlue
        myButton.tintColor = .white
        
        myButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myButton)
        
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 200),
            myButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
