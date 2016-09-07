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
                // Update an existing task
                let dateString = sortedSections[selectedIndexPath.section]
                let newDateTask = dateFormatter.stringFromDate(task.date)
                
                if dateString == newDateTask {
                    sections[dateString]?[selectedIndexPath.row] = task
                }
                else {
                    sections[dateString]?.removeAtIndex(selectedIndexPath.row)
                    addTaskToList(task)
                    if sections[dateString]?.count == 0 {
                        sections.removeValueForKey(dateString)
                    }
                    setSortedSections()
                }
            }
            else {
                // Add a new task
                addTaskToList(task)
                setSortedSections()
            }
            
            saveTasks()
            tableView.reloadData()
        }
    }

    // MARK: Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let taskCountInSection = sections[sortedSections[section]] {
            return taskCountInSection.count
        }
        else {
            return 0
        }
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
        if task!.completed {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task!.title)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.taskTitleLabel.attributedText = attributeString
        } else {
            cell.taskTitleLabel.text = task!.title
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var result = Array<UITableViewRowAction>()
        
        let dateSection = self.sortedSections[indexPath.section]
        if let selectedTask = self.sections[dateSection]?[indexPath.row] {
            
            // Complete Action
            let complete = UITableViewRowAction(style: .Normal, title: "Completar") { action, index in
                
                selectedTask.completed = true
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            complete.backgroundColor = AppColor.gray
            
            // Pending Action
            let pending = UITableViewRowAction(style: .Normal, title: "Pendiente") { action, index in
                
                selectedTask.completed = false
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            pending.backgroundColor = AppColor.gray
            
            // Share Action
            let share = UITableViewRowAction(style: .Normal, title: "Compartir") { action, index in
                
                var shareText = dateSection + " - " + selectedTask.title
                
                if !selectedTask.detail.isEmpty {
                    shareText += ":\n\t* " + selectedTask.detail
                }
                
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
            share.backgroundColor = AppColor.blue
            
            // Delete Action
            let delete = UITableViewRowAction(style: .Normal, title: "Eliminar") { action, index in
                
                self.sections[dateSection]?.removeAtIndex(index.row)
                
                if self.sections[dateSection]?.count == 0 {
                    self.sections.removeValueForKey(dateSection)
                    self.setSortedSections()
                }
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            delete.backgroundColor = UIColor.redColor()
            
            // Select action 
            result.append(delete)
            result.append(share)
            
            if selectedTask.completed {
                result.append(pending)
            }
            else {
                result.append(complete)
            }
            
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
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
        
        let arrayOfTaskArrays = Array(self.sections.values)
        var tasks = Array<Task>()
        
        for taskArray in arrayOfTaskArrays {
            tasks += taskArray
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() -> Bool {
        
        if let tasks = NSKeyedUnarchiver.unarchiveObjectWithFile(Task.ArchiveURL.path!) as? [Task] where tasks.count > 0{
            
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
        self.sortedSections = [String](self.sections.keys.sort(){dateFormatter.dateFromString($0)!.compare(dateFormatter.dateFromString($1)!) == .OrderedAscending})
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
