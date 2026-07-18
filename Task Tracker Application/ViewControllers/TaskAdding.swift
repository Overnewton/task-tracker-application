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
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("←", for: .normal)
        backButton.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        backButton.tintColor = GlobalState.shared.iconColour.UIColor
        backButton.layer.cornerRadius = 25
        backButton.clipsToBounds = true
        view.addSubview(backButton)
        
        let taskTitleInput = UITextField()
        taskTitleInput.translatesAutoresizingMaskIntoConstraints = false
        taskTitleInput.attributedPlaceholder = NSAttributedString(string: "Task Title", attributes: [.foregroundColor: GlobalState.shared.placeholderTextColour.UIColor])
        taskTitleInput.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        taskTitleInput.textColor = GlobalState.shared.textColour.UIColor
        taskTitleInput.layer.borderWidth = 1
        taskTitleInput.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        taskTitleInput.layer.cornerRadius = 8
        taskTitleInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        taskTitleInput.leftViewMode = .always
        taskTitleInput.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        taskTitleInput.rightViewMode = .always
        view.addSubview(taskTitleInput)
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        textView.textColor = GlobalState.shared.textColour.UIColor
        textView.layer.borderWidth = 1
        textView.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = true
        view.addSubview(textView)
        
        //TODO: Center text, add border to everything
        
        let calendarBox = UIView()
        calendarBox.translatesAutoresizingMaskIntoConstraints = false
        calendarBox.layer.borderWidth = 1
        calendarBox.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        calendarBox.layer.cornerRadius = 8
        
        let calendarView = UICalendar()
        let selectedDateLabel = UITextView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let calendarAction = UIAction() { _ in
            calendarView.selectedDates.removeAll()
            calendarView.selectedDates.insert(calendarView.tappedDate)
            selectedDateLabel.text = "\(calendarView.tappedDate)"
        }
        
        calendarView.selectedDates = [ProgramDate.today]
        calendarView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        calendarView.textColor = GlobalState.shared.textColour.UIColor
        calendarView.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        calendarView.addAction(calendarAction, for: .primaryActionTriggered)
        calendarBox.addSubview(calendarView)
        
        selectedDateLabel.text = "\(ProgramDate.today)"
        selectedDateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        selectedDateLabel.textAlignment = .center
        selectedDateLabel.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        selectedDateLabel.textColor = GlobalState.shared.textColour.UIColor
        calendarBox.addSubview(selectedDateLabel)
        view.addSubview(calendarBox)
        
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
            textView.heightAnchor.constraint(equalToConstant: 400),
            
            calendarBox.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            calendarBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            calendarBox.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            calendarView.topAnchor.constraint(equalTo: calendarBox.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: calendarBox.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarBox.trailingAnchor),
            calendarView.heightAnchor.constraint(equalTo: calendarView.widthAnchor, multiplier: 0.7),
            
            selectedDateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            selectedDateLabel.leadingAnchor.constraint(equalTo: calendarBox.leadingAnchor),
            selectedDateLabel.trailingAnchor.constraint(equalTo: calendarBox.trailingAnchor),
            selectedDateLabel.heightAnchor.constraint(equalToConstant: 35),
            
            calendarBox.bottomAnchor.constraint(equalTo: selectedDateLabel.bottomAnchor)
        ])
    }
}
