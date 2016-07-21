//
//  TableViewController.swift
//  Priority Task
//
//  Created by Markez Soft on 31/3/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    // MARK: Model
    
    var sections = [String: [Task]]()
    var sortedSections = [String]()
    
    // MARK: Properties
    
    let dateFormatter = NSDateFormatter()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        // Load any saved meals, otherwise load sample data.
        if !loadTasks() {
            loadSampleTasks()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.separatorStyle = .None
        self.tableView.reloadData()
    }
    
    func loadSampleTasks() {
        
        let task = Task(title: "Ejemplo de tarea normal", detail: "Descripción de tarea normal", date: NSDate(), urgent: false)!
        let urgentTask = Task(title: "Ejemplo de tarea urgente", detail: "Descripción de tarea urgente", date: NSDate(), urgent: true)!
    
        addTaskToList(task)
        addTaskToList(urgentTask)
        
        setSortedSections()
    }
    
    // MARK: Actions
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? TaskViewController, task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                let dateString = sortedSections[selectedIndexPath.section]
                sections[dateString]?[selectedIndexPath.row] = task
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                addTaskToList(task)
                setSortedSections()
                tableView.reloadData()
            }
            
            saveTasks()
        }
    }

    // MARK: Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[sortedSections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskTableViewCell

        let dateSection = sortedSections[indexPath.section]
        let task = sections[dateSection]?[indexPath.row]
        
        // Appearance
        if task!.urgent {
            cell.contentTaskView.backgroundColor = AppColor.transparentGolden
            cell.taskColorMark.backgroundColor = AppColor.golden
            cell.taskTitleLabel.textColor = AppColor.golden
        }
        else {
            cell.contentTaskView.backgroundColor = AppColor.transparentBlue
            cell.taskColorMark.backgroundColor = AppColor.blue
            cell.taskTitleLabel.textColor = AppColor.blue
        }

        cell.contentTaskView.layer.cornerRadius = 10
        cell.contentTaskView.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Task data
        cell.taskTitleLabel.text = task!.title

        return cell
    }
    
    // MARK: TableView Delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        let title = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.width - 10, height: 20))
        title.textColor = AppColor.gray
        title.textAlignment = .Right
        title.text = sortedSections[section]
        headerView.addSubview(title)
        return headerView
    }
    
    // MARK Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowTaskDetail" {
            
            let taskViewController = segue.destinationViewController as! TaskViewController
            
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTaskCell)!
                let dateSection = sortedSections[indexPath.section]
                let selectedTask = sections[dateSection]?[indexPath.row]
                taskViewController.task = selectedTask
            }
        }
    }
    
    // MARK: NSCoding
    
    func saveTasks() {
        let tasks = Array(self.sections.values)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() -> Bool {
        
        if let tasks = NSKeyedUnarchiver.unarchiveObjectWithFile(Task.ArchiveURL.path!) as? [Task]{
            
            for task in tasks {
                self.addTaskToList(task)
            }
            
            setSortedSections()
            self.tableView.reloadData()
            
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Auxiliar methods
    func setSortedSections() {
        self.sortedSections = [String](self.sections.keys).sort() { $0 < $1 }
    }

    func addTaskToList(task: Task) {
        let dateString = dateFormatter.stringFromDate(task.date)
        if self.sections.indexForKey(dateString) == nil {
            self.sections[dateString] = [task]
        }
        else {
            self.sections[dateString]?.append(task)
        }
    }
}
