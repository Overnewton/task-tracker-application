//
//  TaskAdding.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 12/7/2026.
//

import UIKit

class TaskAdding: UIViewController {
    
    var initialTask: ProgramTask = ProgramTask() {
        didSet { reload() }
    }
    
    override func loadView() {
        view = UIView()
        //set background colour to match with the background colour that is stored in the global state
        view.backgroundColor = GlobalState.shared.backgroundColour.UIColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reload()
    }
    
    func reload() {
        //remove all subviews
        view.subviews.forEach { $0.removeFromSuperview() }
        
        //Mostly just UI stuff, would be a storyboard if I was using that.
        let backButtonAction = UIAction() { [weak self] _ in
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
            self?.present(alertController, animated: true, completion: nil)
        }
        
        let btnBack = UIButton(type: .system)
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.addAction(backButtonAction, for: .primaryActionTriggered)
        btnBack.setTitle("←", for: .normal)
        btnBack.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnBack.tintColor = GlobalState.shared.iconColour.UIColor
        btnBack.layer.cornerRadius = 25
        btnBack.clipsToBounds = true
        view.addSubview(btnBack)
        
        let txtTaskTitleInput = UITextField()
        txtTaskTitleInput.translatesAutoresizingMaskIntoConstraints = false
        txtTaskTitleInput.attributedPlaceholder = NSAttributedString(string: "Task Title", attributes: [.foregroundColor: GlobalState.shared.placeholderTextColour.UIColor])
        txtTaskTitleInput.text = initialTask.title
        txtTaskTitleInput.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        txtTaskTitleInput.textColor = GlobalState.shared.textColour.UIColor
        txtTaskTitleInput.layer.borderWidth = 1
        txtTaskTitleInput.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        txtTaskTitleInput.layer.cornerRadius = 8
        txtTaskTitleInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtTaskTitleInput.leftViewMode = .always
        txtTaskTitleInput.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtTaskTitleInput.rightViewMode = .always
        txtTaskTitleInput.addAction(UIAction() { _ in }, for: .editingDidEndOnExit)
        view.addSubview(txtTaskTitleInput)
        
        let txtTaskDescriptionInput = UITextView()
        txtTaskDescriptionInput.text = initialTask.description
        txtTaskDescriptionInput.translatesAutoresizingMaskIntoConstraints = false
        txtTaskDescriptionInput.font = UIFont.systemFont(ofSize: 16)
        txtTaskDescriptionInput.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        txtTaskDescriptionInput.textColor = GlobalState.shared.textColour.UIColor
        txtTaskDescriptionInput.layer.borderWidth = 1
        txtTaskDescriptionInput.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        txtTaskDescriptionInput.layer.cornerRadius = 8
        txtTaskDescriptionInput.isScrollEnabled = true
        view.addSubview(txtTaskDescriptionInput)
        
        let boxCalendar = UIView()
        boxCalendar.translatesAutoresizingMaskIntoConstraints = false
        boxCalendar.layer.borderWidth = 1
        boxCalendar.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxCalendar.layer.cornerRadius = 8
        
        let boxUpperCalendar = UIView()
        let calCalendarView = UICalendar()
        let txtSelectedDate = UITextField()
        let btnUpperCalendarBack = UIButton()
        let btnUpperCalendarForward = UIButton()
        let lblUpperCalendarMonthName = UITextView()
        boxUpperCalendar.translatesAutoresizingMaskIntoConstraints = false
        calCalendarView.translatesAutoresizingMaskIntoConstraints = false
        txtSelectedDate.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarBack.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarForward.translatesAutoresizingMaskIntoConstraints = false
        lblUpperCalendarMonthName.translatesAutoresizingMaskIntoConstraints = false
        
        let actCalendarAction = UIAction() { _ in
            calCalendarView.selectedDates.removeAll()
            calCalendarView.selectedDates.insert(calCalendarView.tappedDate)
            txtSelectedDate.text = "\(calCalendarView.tappedDate)"
        }
        
        let actCalendarBackAction = UIAction() { _ in
            calCalendarView.displayedMonthIndex -= 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calCalendarView.displayedMonthIndex % 12)])"
        }
        
        let actCalendarForwardAction = UIAction() { _ in
            calCalendarView.displayedMonthIndex += 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calCalendarView.displayedMonthIndex % 12)])"
        }
        
        //validates input according to a regular expression, then converts the input back into a date to select
        let actCalendarFromTextAction = UIAction() { _ in
            let regexDateInputValidation: String = "^((0?[1-9]|[1-2][0-9]|3[0-1])\\/(0?[1-9]|1[0-2])\\/[0-9][0-9][0-9][0-9])$"
            if txtSelectedDate.text?.range(of: regexDateInputValidation, options: .regularExpression) != nil {
                let DMY = txtSelectedDate.text?.components(separatedBy: "/")
                let dateVal = ProgramDate(day: (UInt(DMY?[0] ?? "") ?? 1) - 1, month: (UInt(DMY?[1] ?? "") ?? 1) - 1, year: UInt(DMY?[2] ?? "") ?? 1980)
                
                calCalendarView.selectedDates.removeAll()
                calCalendarView.selectedDates.insert(dateVal)
                calCalendarView.displayedMonthIndex = dateVal.months
                txtSelectedDate.text = "\(dateVal)"
            } else {
                
            }
        }
        
        calCalendarView.selectedDates = [initialTask.dueDate]
        calCalendarView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        calCalendarView.textColor = GlobalState.shared.textColour.UIColor
        calCalendarView.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        calCalendarView.highlightColor = GlobalState.shared.highlightColour.UIColor
        calCalendarView.addAction(actCalendarAction, for: .primaryActionTriggered)
        boxCalendar.addSubview(calCalendarView)
        
        txtSelectedDate.text = "\(initialTask.dueDate)"
        txtSelectedDate.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        txtSelectedDate.textAlignment = .center
        txtSelectedDate.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        txtSelectedDate.textColor = GlobalState.shared.textColour.UIColor
        txtSelectedDate.addAction(actCalendarFromTextAction, for: .editingDidEnd)
        txtSelectedDate.addAction(UIAction() { _ in }, for: .editingDidEndOnExit)
        boxCalendar.addSubview(txtSelectedDate)
        
        btnUpperCalendarBack.addAction(actCalendarBackAction, for: .primaryActionTriggered)
        btnUpperCalendarForward.addAction(actCalendarForwardAction, for: .primaryActionTriggered)
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
        
        boxCalendar.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        view.addSubview(boxCalendar)
        
        let boxPropertiesView = UIView()
        let prpPropertiesView = UIProperties()
        boxPropertiesView.translatesAutoresizingMaskIntoConstraints = false
        prpPropertiesView.translatesAutoresizingMaskIntoConstraints = false
        prpPropertiesView.properties = initialTask.properties
        prpPropertiesView.iconColor = GlobalState.shared.iconColour.UIColor
        prpPropertiesView.cellBackgroundColor = GlobalState.shared.foregroundColour.UIColor
        prpPropertiesView.cellBorderColor = GlobalState.shared.borderColour.UIColor
        prpPropertiesView.cellBorderWidth = 1
        prpPropertiesView.cellCornerRadius = 8
        prpPropertiesView.textColor = GlobalState.shared.textColour.UIColor
        prpPropertiesView.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        boxPropertiesView.addSubview(prpPropertiesView)
        
        boxPropertiesView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        boxPropertiesView.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxPropertiesView.layer.borderWidth = 1
        boxPropertiesView.layer.cornerRadius = 8
        view.addSubview(boxPropertiesView)
        
        let btnAddTask = UIButton()
        btnAddTask.translatesAutoresizingMaskIntoConstraints = false
        //adds the task to the list of tasks, removing the previous task unless it hasn't been edited
        let actAddTaskAction = UIAction { [weak self] _ in
            //remove is before insert to fix bug where tasks would be deleted if not edited
            GlobalState.shared.tasks.remove(self?.initialTask ?? ProgramTask())
            GlobalState.shared.tasks.insert(ProgramTask(dueDate: calCalendarView.selectedDates.first ?? ProgramDate.today, title: txtTaskTitleInput.text ?? "", description: txtTaskDescriptionInput.text, properties: prpPropertiesView.properties))
            GlobalState.shared.tasks.remove(ProgramTask())
            GlobalState.shared.save()
            let next = RootViewController()
            GlobalState.switchRoot(to: next)
        }
        
        btnAddTask.addAction(actAddTaskAction, for: .primaryActionTriggered)
        btnAddTask.setTitle("Add Task", for: .normal)
        btnAddTask.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnAddTask.tintColor = GlobalState.shared.iconColour.UIColor
        btnAddTask.layer.cornerRadius = 8
        btnAddTask.clipsToBounds = true
        view.addSubview(btnAddTask)
        
        
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
            
            txtTaskDescriptionInput.topAnchor.constraint(equalTo: txtTaskTitleInput.bottomAnchor, constant: 20),
            txtTaskDescriptionInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            txtTaskDescriptionInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            txtTaskDescriptionInput.heightAnchor.constraint(equalToConstant: 200),
            
            boxPropertiesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxPropertiesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boxPropertiesView.topAnchor.constraint(equalTo: txtTaskDescriptionInput.bottomAnchor, constant: 20),
            boxPropertiesView.heightAnchor.constraint(equalToConstant: 150),
            
            prpPropertiesView.leadingAnchor.constraint(equalTo: boxPropertiesView.leadingAnchor, constant: 10),
            prpPropertiesView.trailingAnchor.constraint(equalTo: boxPropertiesView.trailingAnchor, constant: -10),
            prpPropertiesView.topAnchor.constraint(equalTo: boxPropertiesView.topAnchor, constant: 10),
            prpPropertiesView.bottomAnchor.constraint(equalTo: boxPropertiesView.bottomAnchor, constant: -10),
            
            boxCalendar.topAnchor.constraint(equalTo: boxPropertiesView.bottomAnchor, constant: 20),
            boxCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
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
            calCalendarView.heightAnchor.constraint(equalTo: calCalendarView.widthAnchor, multiplier: 0.4),
            
            txtSelectedDate.topAnchor.constraint(equalTo: calCalendarView.bottomAnchor),
            txtSelectedDate.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            txtSelectedDate.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            txtSelectedDate.heightAnchor.constraint(equalToConstant: 35),
            
            boxCalendar.bottomAnchor.constraint(equalTo: txtSelectedDate.bottomAnchor),
            
            btnAddTask.topAnchor.constraint(equalTo: boxCalendar.bottomAnchor, constant: 20),
            btnAddTask.widthAnchor.constraint(equalToConstant: 100),
            btnAddTask.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnAddTask.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
