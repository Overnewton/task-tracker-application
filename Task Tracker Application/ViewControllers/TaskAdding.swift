//
//  TaskAdding.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 12/7/2026.
//

import UIKit

class TaskAdding: UIViewController {
    
    override func loadView() {
        view = UIView()
        //set background colour to match with the background colour that is stored in the global state
        view.backgroundColor = GlobalState.shared.backgroundColour.UIColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //define UI
        let backButtonAction = UIAction() { _ in
            
            let alertController = UIAlertController(
                title: "Cancel Adding Task",
                message: "Are you sure you want to cancel adding a task?\nYour inputs will not be saved.",
                preferredStyle: .alert // Use .alert for popups, or .actionSheet for bottom slides
            )
            
            let leaveAction = UIAlertAction(title: "Leave", style: .destructive) { _ in
                let next = RootViewController()
                GlobalState.switchRoot(to: next)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(leaveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let backButton = UIButton(type: .system, primaryAction: backButtonAction)
        backButton.setTitle("←", for: .normal)
        backButton.backgroundColor = .systemBlue
        backButton.tintColor = .white
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        let taskTitleInput = UITextField()
        taskTitleInput.placeholder = "\(ProgramDate.today)"
        taskTitleInput.borderStyle = .roundedRect
        taskTitleInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskTitleInput)
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            
            taskTitleInput.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            taskTitleInput.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 12),
            taskTitleInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskTitleInput.heightAnchor.constraint(equalToConstant: 50),
            
            textView.topAnchor.constraint(equalTo: taskTitleInput.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
