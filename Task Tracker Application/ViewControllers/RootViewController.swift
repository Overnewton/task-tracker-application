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
        
        reload()
    }
    
    func reload() {
        //remove all subviews
        view.subviews.forEach { $0.removeFromSuperview() }
        
        //Mostly just UI stuff, would be a storyboard if I was using that
        let boxTaskView = UIView()
        boxTaskView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewData = TaskTableViewData()
        let tblTaskTableView = UITableView()
        tblTaskTableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewData.deleteAllowed = true
        tableViewData.reload = { [weak tblTaskTableView] in
            tblTaskTableView?.reloadData()
        }
        tableViewData.onPress = { x in
            let next = TaskAdding()
            next.initialTask = x
            GlobalState.switchRoot(to: next)
        }
        let funcConfigureCell: (inout UITableViewCell, ProgramTask) -> Void = { cell, task in
            var cellContent = cell.defaultContentConfiguration()
            cellContent.text = task.title
            cellContent.secondaryText = String(task.description.prefix(50)) + (task.description.count > 50 ? "..." : "")
            cellContent.textProperties.color = GlobalState.shared.textColour.UIColor
            cellContent.secondaryTextProperties.color = GlobalState.shared.placeholderTextColour.UIColor
            cell.contentConfiguration = cellContent
            cell.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        }
        tableViewData.configureCells = funcConfigureCell
        tblTaskTableView.dataSource = tableViewData
        tblTaskTableView.delegate = tableViewData
        tblTaskTableView.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        tblTaskTableView.layer.cornerRadius = 8
        tblTaskTableView.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        tblTaskTableView.layer.borderWidth = 1
        tblTaskTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewData.reload()
        boxTaskView.addSubview(tblTaskTableView)
        
        let btnSort = UIButton(type: .system)
        btnSort.translatesAutoresizingMaskIntoConstraints = false
        btnSort.setTitle("  Sort: Alphabetical (A→Z)", for: .normal)
        btnSort.tintColor = GlobalState.shared.textColour.UIColor
        btnSort.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnSort.layer.cornerRadius = 8
        btnSort.layer.borderWidth = 1
        btnSort.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        btnSort.contentHorizontalAlignment = .left
        let sortMenu = UIMenu(children: [
            UIAction(title: "  Sort: Alphabetical (A→Z)") { _ in
                tableViewData.sort = { $0.title < $1.title }
            },
            UIAction(title: "  Sort: Alphabetical (Z→A)") { _ in
                tableViewData.sort = {$0.title > $1.title }
            },
            UIAction(title: "  Sort: Due Date (Sooner First)") { _ in
                tableViewData.sort = { $0.dueDate < $1.dueDate }
            },
            UIAction(title: "  Sort: Due Date (Sooner Later)") { _ in
                tableViewData.sort = { $0.dueDate > $1.dueDate }
            }
        ])
        btnSort.menu = sortMenu
        btnSort.showsMenuAsPrimaryAction = true
        btnSort.changesSelectionAsPrimaryAction = true
        boxTaskView.addSubview(btnSort)
        
        let btnNewTask = UIButton(type: .system)
        btnNewTask.translatesAutoresizingMaskIntoConstraints = false
        let actNewTask = UIAction() { _ in
            let next = TaskAdding()
            GlobalState.switchRoot(to: next)
        }
        btnNewTask.setTitle("+", for: .normal)
        btnNewTask.addAction(actNewTask, for: .primaryActionTriggered)
        btnNewTask.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnNewTask.tintColor = GlobalState.shared.textColour.UIColor
        btnNewTask.layer.cornerRadius = 8
        btnNewTask.layer.borderWidth = 1
        btnNewTask.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxTaskView.addSubview(btnNewTask)
        
        let txtFilter = UITextField()
        txtFilter.translatesAutoresizingMaskIntoConstraints = false
        txtFilter.attributedPlaceholder = NSAttributedString(string: "Filter", attributes: [.foregroundColor: GlobalState.shared.placeholderTextColour.UIColor])
        txtFilter.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtFilter.leftViewMode = .always
        txtFilter.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        txtFilter.rightViewMode = .always
        let actFilter = UIAction() { _ in
            tableViewData.reload()
        }
        txtFilter.addAction(actFilter, for: .editingChanged)
        txtFilter.textColor = GlobalState.shared.textColour.UIColor
        txtFilter.textAlignment = .left
        txtFilter.layer.cornerRadius = 4
        txtFilter.layer.borderWidth = 1
        txtFilter.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        txtFilter.addAction(UIAction() { _ in }, for: .editingDidEndOnExit)
        boxTaskView.addSubview(txtFilter)
        view.addSubview(boxTaskView)
        
        let actReloadSubview = UIAction() { _ in
            tableViewData.reload()
        }
        
        let boxMustInclude = UIView()
        let prpMustInclude = UIProperties()
        let lblMustInclude = UILabel()
        boxMustInclude.translatesAutoresizingMaskIntoConstraints = false
        prpMustInclude.translatesAutoresizingMaskIntoConstraints = false
        lblMustInclude.translatesAutoresizingMaskIntoConstraints = false
        prpMustInclude.iconColor = GlobalState.shared.iconColour.UIColor
        prpMustInclude.cellBackgroundColor = GlobalState.shared.foregroundColour.UIColor
        prpMustInclude.cellBorderColor = GlobalState.shared.borderColour.UIColor
        prpMustInclude.cellBorderWidth = 1
        prpMustInclude.cellCornerRadius = 8
        prpMustInclude.textColor = GlobalState.shared.textColour.UIColor
        prpMustInclude.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        prpMustInclude.addAction(actReloadSubview, for: .primaryActionTriggered)
        boxMustInclude.addSubview(prpMustInclude)
        
        lblMustInclude.text = "Included"
        lblMustInclude.textColor = GlobalState.shared.textColour.UIColor
        boxMustInclude.addSubview(lblMustInclude)
        
        let segIncludeMode = UISegmentedControl(items: ["All", "At Least 1"])
        segIncludeMode.translatesAutoresizingMaskIntoConstraints = false
        segIncludeMode.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        segIncludeMode.setTitleTextAttributes([
            .foregroundColor: GlobalState.shared.textColour.UIColor,
        ], for: .normal)
        segIncludeMode.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        segIncludeMode.layer.borderWidth = 1
        segIncludeMode.layer.cornerRadius = 8
        segIncludeMode.selectedSegmentIndex = 0
        segIncludeMode.selectedSegmentTintColor = GlobalState.shared.iconColour.UIColor.withAlphaComponent(0.8)
        segIncludeMode.addAction(actReloadSubview, for: .valueChanged)
        boxMustInclude.addSubview(segIncludeMode)
        
        boxMustInclude.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        boxMustInclude.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxMustInclude.layer.borderWidth = 1
        boxMustInclude.layer.cornerRadius = 8
        view.addSubview(boxMustInclude)
        
        let boxMustExclude = UIView()
        let prpMustExclude = UIProperties()
        let lblMustExclude = UILabel()
        boxMustExclude.translatesAutoresizingMaskIntoConstraints = false
        prpMustExclude.translatesAutoresizingMaskIntoConstraints = false
        lblMustExclude.translatesAutoresizingMaskIntoConstraints = false
        prpMustExclude.iconColor = GlobalState.shared.iconColour.UIColor
        prpMustExclude.cellBackgroundColor = GlobalState.shared.foregroundColour.UIColor
        prpMustExclude.cellBorderColor = GlobalState.shared.borderColour.UIColor
        prpMustExclude.cellBorderWidth = 1
        prpMustExclude.cellCornerRadius = 8
        prpMustExclude.textColor = GlobalState.shared.textColour.UIColor
        prpMustExclude.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        prpMustExclude.addAction(actReloadSubview, for: .primaryActionTriggered)
        boxMustExclude.addSubview(prpMustExclude)
        
        lblMustExclude.text = "Excluded"
        lblMustExclude.textColor = GlobalState.shared.textColour.UIColor
        boxMustExclude.addSubview(lblMustExclude)
        
        boxMustExclude.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        boxMustExclude.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxMustExclude.layer.borderWidth = 1
        boxMustExclude.layer.cornerRadius = 8
        view.addSubview(boxMustExclude)
        
        let boxCalendar = UIView()
        boxCalendar.translatesAutoresizingMaskIntoConstraints = false
        boxCalendar.layer.borderWidth = 1
        boxCalendar.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxCalendar.layer.cornerRadius = 8
        
        let boxUpperCalendar = UIView()
        let calDateRange = UICalendar()
        let btnUpperCalendarBack = UIButton()
        let btnUpperCalendarForward = UIButton()
        let lblUpperCalendarMonthName = UITextView()
        let btnResetSelectedDates = UIButton()
        boxUpperCalendar.translatesAutoresizingMaskIntoConstraints = false
        calDateRange.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarBack.translatesAutoresizingMaskIntoConstraints = false
        btnUpperCalendarForward.translatesAutoresizingMaskIntoConstraints = false
        lblUpperCalendarMonthName.translatesAutoresizingMaskIntoConstraints = false
        btnResetSelectedDates.translatesAutoresizingMaskIntoConstraints = false
        
        let actCalendarAction = UIAction() { _ in
            switch calDateRange.selectedDates.contains(calDateRange.tappedDate) {
            case true:
                calDateRange.selectedDates.remove(calDateRange.tappedDate)
            case false:
                calDateRange.selectedDates.insert(calDateRange.tappedDate)
            }
            tableViewData.reload()
        }
        
        let actCalendarBackAction = UIAction() { _ in
            calDateRange.displayedMonthIndex -= 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calDateRange.displayedMonthIndex % 12)])"
        }
        
        let actCalendarForwardAction = UIAction() { _ in
            calDateRange.displayedMonthIndex += 1
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calDateRange.displayedMonthIndex % 12)])"
        }
        
        let actCalendarResetAction = UIAction() { _ in
            calDateRange.selectedDates.removeAll()
            calDateRange.displayedMonthIndex = ProgramDate.today.months
            lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calDateRange.displayedMonthIndex % 12)])"
            tableViewData.reload()
        }
        
        calDateRange.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        calDateRange.textColor = GlobalState.shared.textColour.UIColor
        calDateRange.secondaryTextColor = GlobalState.shared.placeholderTextColour.UIColor
        calDateRange.highlightColor = GlobalState.shared.highlightColour.UIColor
        calDateRange.addAction(actCalendarAction, for: .primaryActionTriggered)
        boxCalendar.addSubview(calDateRange)
        
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
        
        lblUpperCalendarMonthName.text = "\(ProgramDate.monthNames[Int(calDateRange.displayedMonthIndex % 12)])"
        lblUpperCalendarMonthName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lblUpperCalendarMonthName.textAlignment = .center
        lblUpperCalendarMonthName.backgroundColor = .clear
        lblUpperCalendarMonthName.textColor = GlobalState.shared.textColour.UIColor
        lblUpperCalendarMonthName.isEditable = false
        boxUpperCalendar.addSubview(lblUpperCalendarMonthName)
        boxCalendar.addSubview(boxUpperCalendar)
        
        btnResetSelectedDates.addAction(actCalendarResetAction, for: .primaryActionTriggered)
        btnResetSelectedDates.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        btnResetSelectedDates.setTitle("Reset Calendar", for: .normal)
        btnResetSelectedDates.layer.cornerRadius = 8
        btnResetSelectedDates.layer.borderWidth = 1
        btnResetSelectedDates.layer.borderColor = GlobalState.shared.borderColour.UIColor.cgColor
        boxCalendar.addSubview(btnResetSelectedDates)
        
        boxCalendar.backgroundColor = GlobalState.shared.foregroundColour.UIColor
        view.addSubview(boxCalendar)
        
        //Filtering Method
        tableViewData.filter = { [weak txtFilter, weak prpMustInclude, weak prpMustExclude, weak calDateRange, weak segIncludeMode] x in
            //Checks if the title matches the filter
            let titleCheck = x.title.lowercased().contains(txtFilter?.text?.lowercased() ?? "") || txtFilter?.text?.isEmpty ?? true
            //Checks if the properties match the properties it should include when filtering
            let includedPropertiesCheck = (segIncludeMode?.selectedSegmentIndex == 0 ? prpMustInclude?.properties.allSatisfy(x.properties.contains) : prpMustInclude?.properties.contains(where: x.properties.contains)) ?? true || prpMustInclude?.properties.isEmpty ?? true
            //Checks if the properties do not contain any excluded properties
            let excludedPropertiesCheck = !(prpMustExclude?.properties.contains(where: x.properties.contains) ?? true) || prpMustExclude?.properties.isEmpty ?? true
            //Checks if the date is one of the selected dates (if there are no selected dates, it treats it as if every date is selected, for UX reasons)
            let dateCheck = calDateRange?.selectedDates.contains(x.dueDate) ?? true || ((calDateRange?.selectedDates.isEmpty) ?? true)
            
            return titleCheck && includedPropertiesCheck && excludedPropertiesCheck && dateCheck
        }
        
        NSLayoutConstraint.activate([
            
            boxTaskView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            boxTaskView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxTaskView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            btnSort.topAnchor.constraint(equalTo: boxTaskView.topAnchor, constant: 10),
            btnSort.leadingAnchor.constraint(equalTo: boxTaskView.leadingAnchor),
            btnSort.trailingAnchor.constraint(equalTo: btnNewTask.leadingAnchor, constant: -10),
            btnSort.heightAnchor.constraint(equalToConstant: 34),
            
            btnNewTask.centerYAnchor.constraint(equalTo: btnSort.centerYAnchor),
            btnNewTask.trailingAnchor.constraint(equalTo: boxTaskView.trailingAnchor),
            btnNewTask.widthAnchor.constraint(equalToConstant: 34),
            btnNewTask.heightAnchor.constraint(equalToConstant: 34),
            
            tblTaskTableView.topAnchor.constraint(equalTo: btnSort.bottomAnchor, constant: 10),
            tblTaskTableView.leadingAnchor.constraint(equalTo: boxTaskView.leadingAnchor),
            tblTaskTableView.trailingAnchor.constraint(equalTo: boxTaskView.trailingAnchor),
            
            txtFilter.topAnchor.constraint(equalTo: tblTaskTableView.bottomAnchor, constant: 10),
            txtFilter.leadingAnchor.constraint(equalTo: boxTaskView.leadingAnchor),
            txtFilter.trailingAnchor.constraint(equalTo: boxTaskView.trailingAnchor),
            txtFilter.heightAnchor.constraint(equalToConstant: 32),
            
            txtFilter.bottomAnchor.constraint(equalTo: boxTaskView.bottomAnchor),
            
            boxMustInclude.topAnchor.constraint(equalTo: boxTaskView.bottomAnchor, constant: 15),
            boxMustInclude.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxMustInclude.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            lblMustInclude.topAnchor.constraint(equalTo: boxMustInclude.topAnchor, constant: 6),
            lblMustInclude.leadingAnchor.constraint(equalTo: boxMustInclude.leadingAnchor, constant: 10),
            lblMustInclude.heightAnchor.constraint(equalToConstant: 20),
            
            segIncludeMode.centerYAnchor.constraint(equalTo: lblMustInclude.centerYAnchor),
            segIncludeMode.trailingAnchor.constraint(equalTo: boxMustInclude.trailingAnchor, constant: -10),
            segIncludeMode.widthAnchor.constraint(equalToConstant: 150),
            segIncludeMode.heightAnchor.constraint(equalToConstant: 24),
            
            prpMustInclude.topAnchor.constraint(equalTo: lblMustInclude.bottomAnchor, constant: 10),
            prpMustInclude.leadingAnchor.constraint(equalTo: boxMustInclude.leadingAnchor, constant: 10),
            prpMustInclude.trailingAnchor.constraint(equalTo: boxMustInclude.trailingAnchor, constant: -10),
            prpMustInclude.heightAnchor.constraint(equalToConstant: 70),
            prpMustInclude.bottomAnchor.constraint(equalTo: boxMustInclude.bottomAnchor, constant: -10),
            
            boxMustExclude.topAnchor.constraint(equalTo: boxMustInclude.bottomAnchor, constant: 15),
            boxMustExclude.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxMustExclude.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            lblMustExclude.topAnchor.constraint(equalTo: boxMustExclude.topAnchor, constant: 6),
            lblMustExclude.leadingAnchor.constraint(equalTo: boxMustExclude.leadingAnchor, constant: 10),
            lblMustExclude.heightAnchor.constraint(equalToConstant: 20),
            
            prpMustExclude.topAnchor.constraint(equalTo: lblMustExclude.bottomAnchor, constant: 10),
            prpMustExclude.leadingAnchor.constraint(equalTo: boxMustExclude.leadingAnchor, constant: 10),
            prpMustExclude.trailingAnchor.constraint(equalTo: boxMustExclude.trailingAnchor, constant: -10),
            prpMustExclude.heightAnchor.constraint(equalToConstant: 70),
            prpMustExclude.bottomAnchor.constraint(equalTo: boxMustExclude.bottomAnchor, constant: -10),
            
            boxCalendar.topAnchor.constraint(equalTo: boxMustExclude.bottomAnchor, constant: 15),
            boxCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boxCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boxCalendar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            boxUpperCalendar.topAnchor.constraint(equalTo: boxCalendar.topAnchor),
            boxUpperCalendar.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            boxUpperCalendar.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            boxUpperCalendar.heightAnchor.constraint(equalToConstant: 40),
            
            btnUpperCalendarBack.leadingAnchor.constraint(equalTo: boxUpperCalendar.leadingAnchor, constant: 10),
            btnUpperCalendarBack.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            btnUpperCalendarBack.widthAnchor.constraint(equalToConstant: 20),
            btnUpperCalendarBack.heightAnchor.constraint(equalToConstant: 20),
            
            btnUpperCalendarForward.trailingAnchor.constraint(equalTo: boxUpperCalendar.trailingAnchor, constant: -10),
            btnUpperCalendarForward.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            btnUpperCalendarForward.widthAnchor.constraint(equalToConstant: 20),
            btnUpperCalendarForward.heightAnchor.constraint(equalToConstant: 20),
            
            lblUpperCalendarMonthName.leadingAnchor.constraint(equalTo: btnUpperCalendarBack.trailingAnchor),
            lblUpperCalendarMonthName.trailingAnchor.constraint(equalTo: btnUpperCalendarForward.leadingAnchor),
            lblUpperCalendarMonthName.centerYAnchor.constraint(equalTo: boxUpperCalendar.centerYAnchor),
            lblUpperCalendarMonthName.heightAnchor.constraint(equalTo: boxUpperCalendar.heightAnchor),
            
            calDateRange.topAnchor.constraint(equalTo: boxUpperCalendar.bottomAnchor),
            calDateRange.leadingAnchor.constraint(equalTo: boxCalendar.leadingAnchor),
            calDateRange.trailingAnchor.constraint(equalTo: boxCalendar.trailingAnchor),
            calDateRange.heightAnchor.constraint(equalTo: calDateRange.widthAnchor, multiplier: 0.40),
            
            btnResetSelectedDates.topAnchor.constraint(equalTo: calDateRange.bottomAnchor, constant: 10),
            btnResetSelectedDates.centerXAnchor.constraint(equalTo: boxCalendar.centerXAnchor),
            btnResetSelectedDates.widthAnchor.constraint(equalToConstant: 150),
            btnResetSelectedDates.heightAnchor.constraint(equalToConstant: 24),
            btnResetSelectedDates.bottomAnchor.constraint(equalTo: boxCalendar.bottomAnchor, constant: -10),
        ])
    }
}
