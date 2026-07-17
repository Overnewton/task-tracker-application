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
        let resetButtonAction = UIAction(title: "Reset") { _ in
            GlobalState.reset()
        }
        
        
        let myButton = UIButton(type: .system, primaryAction: buttonAction)
        let resetButton = UIButton(type: .system, primaryAction: resetButtonAction)
        
        myButton.backgroundColor = .systemBlue
        myButton.tintColor = .white
        
        resetButton.backgroundColor = .systemBlue
        resetButton.tintColor = .white
        
        myButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myButton)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myButton.widthAnchor.constraint(equalToConstant: 200),
            myButton.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: myButton.bottomAnchor, constant: 20),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
