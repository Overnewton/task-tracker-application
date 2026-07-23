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
        
        //UI Elements
        let backButtonAction = UIAction() { _ in
            
            let alertController = UIAlertController(
                title: "Cancel Adding Task",
                message: "Are you sure you want to cancel adding a task?\nYour inputs will not be saved.",
                preferredStyle: .alert
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
        
        let btnBack = UIButton(type: .system, primaryAction: backButtonAction)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.setTitle("←", for: .normal)
        btnBack.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnBack.tintColor = GlobalState.shared.iconColour.UIColor
        btnBack.layer.cornerRadius = 25
        btnBack.clipsToBounds = true
        view.addSubview(btnBack)
        
        let txtTaskTitleInput = UITextField()
        txtTaskTitleInput.translatesAutoresizingMaskIntoConstraints = false
        txtTaskTitleInput.attributedPlaceholder = NSAttributedString(string: "Task Title", attributes: [.foregroundColor: GlobalState.shared.placeholderTextColour.UIColor])
        txtTaskTitleInput.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        txtTaskTitleInput.textColor = GlobalState.shared.textColour.UIColor
        txtTaskTitleInput.layer.borderWidth = 1
        txtTaskTitleInput.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        txtTaskTitleInput.layer.cornerRadius = 8
        txtTaskTitleInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtTaskTitleInput.leftViewMode = .always
        txtTaskTitleInput.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtTaskTitleInput.rightViewMode = .always
        view.addSubview(txtTaskTitleInput)
        
        let txtTextView = UITextView()
        txtTextView.translatesAutoresizingMaskIntoConstraints = false
        txtTextView.font = UIFont.systemFont(ofSize: 16)
        txtTextView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        txtTextView.textColor = GlobalState.shared.textColour.UIColor
        txtTextView.layer.borderWidth = 1
        txtTextView.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        txtTextView.layer.cornerRadius = 8
        txtTextView.isScrollEnabled = true
        view.addSubview(txtTextView)
        
        let boxCalendar = UIView()
        boxCalendar.translatesAutoresizingMaskIntoConstraints = false
        boxCalendar.layer.borderWidth = 1
        boxCalendar.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxCalendar.layer.cornerRadius = 8
        
        let boxUpperCalendar = UIView()
        let calCalendarView = UICalendar()
        let lblSelectedDate = UITextView()
        let btnUpperCalendarBack = UIButton()
        let btnUpperCalendarForward = UIButton()
        let lblUpperCalendarMonthName = UITextView()
        boxUpperCalendar.translatesAutoresizingMaskIntoConstraints = false
        calCalendarView.translatesAutoresizingMaskIntoConstraints = false
        lblSelectedDate.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarBack.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarForward.translatesAutoresizingMaskIntoConstraints = false
        lblUpperCalendarMonthName.translatesAutoresizingMaskIntoConstraints = false
        
        let calendarAction = UIAction() { _ in
            calCalendarView.selectedDates.removeAll()
            calCalendarView.selectedDates.insert(calCalendarView.tappedDate)
            lblSelectedDate.text = "\(calCalendarView.tappedDate)"
        }
        
        let calendarBackAction = UIAction() { _ in
            calCalendarView.displayedMonthIndex -= 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calCalendarView.displayedMonthIndex % 12)])"
        }
        
        let calendarForwardAction = UIAction() { _ in
            calCalendarView.displayedMonthIndex += 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calCalendarView.displayedMonthIndex % 12)])"
        }
        
        calCalendarView.selectedDates = [ProgramDate.today]
        calCalendarView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        calCalendarView.textColor = GlobalState.shared.textColour.UIColor
        calCalendarView.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        calCalendarView.highlightColor = GlobalState.shared.highlightColour.UIColor
        calCalendarView.addAction(calendarAction, for: .primaryActionTriggered)
        boxCalendar.addSubview(calCalendarView)
        
        lblSelectedDate.text = "\(ProgramDate.today)"
        lblSelectedDate.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lblSelectedDate.textAlignment = .center
        lblSelectedDate.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        lblSelectedDate.textColor = GlobalState.shared.textColour.UIColor
        lblSelectedDate.isEditable = false
        boxCalendar.addSubview(lblSelectedDate)
        
        btnUpperCalendarBack.addAction(calendarBackAction, for: .primaryActionTriggered)
        btnUpperCalendarForward.addAction(calendarForwardAction, for: .primaryActionTriggered)
        btnUpperCalendarBack.setTitle("‹", for: .normal)
        btnUpperCalendarForward.setTitle("›", for: .normal)
        btnUpperCalendarBack.backgroundColor = .clear
        btnUpperCalendarForward.backgroundColor = .clear
        btnUpperCalendarBack.tintColor = GlobalState.shared.iconColour.UIColor
        btnUpperCalendarForward.tintColor = GlobalState.shared.iconColour.UIColor
        btnUpperCalendarBack.layer.cornerRadius = 15
        btnUpperCalendarForward.layer.cornerRadius = 15
        btnUpperCalendarBack.clipsToBounds = true
        btnUpperCalendarForward.clipsToBounds = true
        boxUpperCalendar.addSubview(btnUpperCalendarBack)
        boxUpperCalendar.addSubview(btnUpperCalendarForward)
        
        lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calCalendarView.displayedMonthIndex % 12)])"
        lblUpperCalendarMonthName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lblUpperCalendarMonthName.textAlignment = .center
        lblUpperCalendarMonthName.backgroundColor = .clear
        lblUpperCalendarMonthName.textColor = GlobalState.shared.textColour.UIColor
        lblUpperCalendarMonthName.isEditable = false
        boxUpperCalendar.addSubview(lblUpperCalendarMonthName)
        
        boxCalendar.addSubview(boxUpperCalendar)
        
        view.addSubview(boxCalendar)
        
        //UI Layout
        NSLayoutConstraint.activate([
            btnBack.widthAnchor.constraint(equalToConstant: 50),
            btnBack.heightAnchor.constraint(equalToConstant: 50),
            btnBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btnBack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            
            txtTaskTitleInput.centerYAnchor.constraint(equalTo: btnBack.centerYAnchor),
            txtTaskTitleInput.leadingAnchor.constraint(equalTo: btnBack.trailingAnchor, constant: 12),
            txtTaskTitleInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            txtTaskTitleInput.heightAnchor.constraint(equalToConstant: 50),
            
            txtTextView.topAnchor.constraint(equalTo: txtTaskTitleInput.bottomAnchor, constant: 20),
            txtTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            txtTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            txtTextView.heightAnchor.constraint(equalToConstant: 400),
            
            boxCalendar.topAnchor.constraint(equalTo: txtTextView.bottomAnchor, constant: 20),
            boxCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxCalendar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            
            boxUpperCalendar.topAnchor.constraint(equalTo: boxCalendar.topAnchor),
            boxUpperCalendar.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            boxUpperCalendar.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            boxUpperCalendar.heightAnchor.constraint(equalToConstant: 35),
            
            btnUpperCalendarBack.leadingAnchor.constraint(equalTo: boxUpperCalendar.leadingAnchor),
            btnUpperCalendarForward.trailingAnchor.constraint(equalTo: boxUpperCalendar.trailingAnchor),
            btnUpperCalendarBack.widthAnchor.constraint(equalToConstant: 30),
            btnUpperCalendarForward.widthAnchor.constraint(equalToConstant: 30),
            btnUpperCalendarBack.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            btnUpperCalendarForward.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            
            lblUpperCalendarMonthName.leadingAnchor.constraint(equalTo: btnUpperCalendarBack.trailingAnchor),
            lblUpperCalendarMonthName.trailingAnchor.constraint(equalTo: btnUpperCalendarForward.leadingAnchor),
            lblUpperCalendarMonthName.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            lblUpperCalendarMonthName.heightAnchor.constraint(equalTo: boxUpperCalendar.heightAnchor),
            
            calCalendarView.topAnchor.constraint(equalTo: boxUpperCalendar.bottomAnchor),
            calCalendarView.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            calCalendarView.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            calCalendarView.heightAnchor.constraint(equalTo: calCalendarView.widthAnchor, multiplier: 0.7),
            
            lblSelectedDate.topAnchor.constraint(equalTo: calCalendarView.bottomAnchor),
            lblSelectedDate.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            lblSelectedDate.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            lblSelectedDate.heightAnchor.constraint(equalToConstant: 35),
            
            boxCalendar.bottomAnchor.constraint(equalTo: lblSelectedDate.bottomAnchor)
        ])
    }
}
