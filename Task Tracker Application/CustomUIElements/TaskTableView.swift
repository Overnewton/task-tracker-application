//
//  TaskTableViewDataSource.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 31/7/2026.
//

import UIKit

class TaskTableViewData: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    //is deleting allwed (bool as there are 2 valid states)
    var deleteAllowed: Bool = false
    
    //function to reload the table views (function as it needs to be executed when needed)
    var reload: () -> Void = {}
    
    //defines the ordering (function as that is how swift represents orderings)
    var sort: (ProgramTask, ProgramTask) -> Bool = { $0.title < $1.title } {
        didSet {
            reload()
        }
    }
    
    //filter (function that returns if a program task should be displayed)
    var filter: (ProgramTask) -> Bool = { _ in true }  {
        didSet {
            reload()
        }
    }
    
    //what to do when an item is pressed
    var onPress: (ProgramTask) -> Void = { _ in }
    
    //configuration of the cells
    var configureCells: (inout UITableViewCell, ProgramTask) -> Void = { _, _ in }
    
    //sorted and filtered collection of tasks
    var data: [ProgramTask] {
        let unfiltered = Array(GlobalState.shared.tasks).sorted(by: sort)
        var filtered: Array<ProgramTask> = []
        for task in unfiltered {
            if filter(task) {
                filtered.append(task)
            }
        }
        return filtered
    }
    
    //MARK: tableView functions
    //mostly boilerplate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = data[indexPath.row]
        
        //ensure the cell identifier has been labelled "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCells(&cell, element)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let element = data[indexPath.row]
        if editingStyle == .delete {
            if deleteAllowed {
                GlobalState.shared.tasks.remove(element)
                GlobalState.shared.save()
                reload()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = data[indexPath.row]
        onPress(element)
    }
}
