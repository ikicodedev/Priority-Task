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
    
    let dateFormatter = DateFormatter()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        // Load any saved meals, otherwise load sample data.
        if !loadTasks() {
            loadSampleTasks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
    }
    
    func loadSampleTasks() {
        
        let task = Task(title: "Ejemplo de tarea normal", detail: "Descripción de tarea normal", date: Date(), urgent: false)!
        let urgentTask = Task(title: "Ejemplo de tarea urgente", detail: "Descripción de tarea urgente", date: Date(), urgent: true)!
    
        addTaskToList(task)
        addTaskToList(urgentTask)
        
        setSortedSections()
    }
    
    // MARK: Actions
    @IBAction func unwindToTaskList(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task
                let dateString = sortedSections[(selectedIndexPath as NSIndexPath).section]
                let newDateTask = dateFormatter.string(from: task.date as Date)
                
                if dateString == newDateTask {
                    sections[dateString]?[(selectedIndexPath as NSIndexPath).row] = task
                }
                else {
                    sections[dateString]?.remove(at: (selectedIndexPath as NSIndexPath).row)
                    addTaskToList(task)
                    if sections[dateString]?.count == 0 {
                        sections.removeValue(forKey: dateString)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if sortedSections.count == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "Todas las tareas han sido completadas"
            noDataLabel.textColor = AppColor.blue
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
        } else {
            tableView.backgroundView = nil
        }
        
        return sortedSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let taskCountInSection = sections[sortedSections[section]] {
            return taskCountInSection.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell

        let dateSection = sortedSections[(indexPath as NSIndexPath).section]
        let task = sections[dateSection]?[(indexPath as NSIndexPath).row]
        
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var result = Array<UITableViewRowAction>()
        
        let dateSection = self.sortedSections[(indexPath as NSIndexPath).section]
        if let selectedTask = self.sections[dateSection]?[(indexPath as NSIndexPath).row] {
            
            // Complete Action
            let complete = UITableViewRowAction(style: .normal, title: "Completar") { action, index in
                
                selectedTask.completed = true
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            complete.backgroundColor = AppColor.golden
            
            // Pending Action
            let pending = UITableViewRowAction(style: .normal, title: "Pendiente") { action, index in
                
                selectedTask.completed = false
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            pending.backgroundColor = AppColor.golden
            
            // Share Action
            let share = UITableViewRowAction(style: .normal, title: "Compartir") { action, index in
                
                var shareText = dateSection + " - " + selectedTask.title
                
                if !selectedTask.detail.isEmpty {
                    shareText += ":\n\t* " + selectedTask.detail
                }
                
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                self.present(vc, animated: true, completion: nil)
                
            }
            share.backgroundColor = AppColor.blue
            
            // Delete Action
            let delete = UITableViewRowAction(style: .normal, title: "Eliminar") { action, index in
                
                self.sections[dateSection]?.remove(at: (index as NSIndexPath).row)
                
                if self.sections[dateSection]?.count == 0 {
                    self.sections.removeValue(forKey: dateSection)
                    self.setSortedSections()
                }
                
                self.saveTasks()
                tableView.reloadData()
                
            }
            delete.backgroundColor = UIColor.red
            
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    // MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let title = UILabel(frame: CGRect(x: 0, y: 5, width: self.view.frame.width - 10, height: 20))
        title.textColor = AppColor.gray
        title.textAlignment = .right
        title.text = sortedSections[section]
        headerView.addSubview(title)
        return headerView
    }
    
    // MARK Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTaskDetail" {
            
            let taskViewController = segue.destination as! TaskViewController
            
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPath(for: selectedTaskCell)!
                let dateSection = sortedSections[(indexPath as NSIndexPath).section]
                let selectedTask = sections[dateSection]?[(indexPath as NSIndexPath).row]
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
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() -> Bool {
        
        if let tasks = NSKeyedUnarchiver.unarchiveObject(withFile: Task.ArchiveURL.path) as? [Task] {
            
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
        self.sortedSections = [String](self.sections.keys.sorted(){dateFormatter.date(from: $0)!.compare(dateFormatter.date(from: $1)!) == .orderedAscending})
    }

    func addTaskToList(_ task: Task) {
        let dateString = dateFormatter.string(from: task.date as Date)
        if self.sections.index(forKey: dateString) == nil {
            self.sections[dateString] = [task]
        }
        else {
            self.sections[dateString]?.append(task)
        }
    }
}
