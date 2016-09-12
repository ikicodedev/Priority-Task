//
//  TaskViewController.swift
//  Priority Task
//
//  Created by Jose Manuel Márquez Pavón on 18/7/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Constants
    
    let DESCRIPTION_TASK_PLACEHOLDER = "Descripción de la tarea"
    let NAVIGATION_BAR_TITLE_SIZE = 15
    
    // MARK: Outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var completeLabel: UILabel!
    
    // MARK: Model
    
    var task: Task?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleTextField.delegate = self
        
        self.completeLabel.hidden = true
        
        // Description placeholder
        descriptionTextView.delegate = self
        if (descriptionTextView.text.isEmpty) {
            textViewDidEndEditing(descriptionTextView)
        }
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissDescriptionKeyboard))
        self.view.addGestureRecognizer(tapDismiss)
        
        self.setTaskDate(NSDate())
        
        if let task = task {
            setNavigationBarTitle(task.title)
            titleTextField.text = task.title
            descriptionTextView.text = task.detail
            self.setTaskDate(task.date)
            urgentSwitch.on = task.urgent
            
            if task.completed {
                self.completeLabel.hidden = false
            }
        }
        
        // Enable the Save button only if the title field is valid.
        checkValidTaskName()
    }
    
    // MARK: Actions
    
    @IBAction func dateEditing(sender: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.timeZone = NSTimeZone.localTimeZone()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        if let dateText = dateTextField.text where !dateText.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            datePickerView.date = dateFormatter.dateFromString(dateText)!
        }
        
        let doneButton = UIBarButtonItem(title: "Hecho", style: .Done, target: self, action: #selector(doneDateButton))
        doneButton.tintColor = AppColor.blue
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
    }
    
    func doneDateButton(sender:UIButton)
    {
        dateTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let currentDate = NSDate()
        
        if NSCalendar.currentCalendar().compareDate(currentDate, toDate:sender.date, toUnitGranularity:NSCalendarUnit.Day) == NSComparisonResult.OrderedDescending {
            
            let alert = UIAlertController(title: "Atención", message: "La fecha tiene que ser la de hoy o una futura", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else {
            self.setTaskDate(sender.date)
        }
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        checkValidTaskName()
        
        if let title = textField.text {
            
            setNavigationBarTitle(title)
            
        }
    }
    
    func checkValidTaskName() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? String()
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UITextViewDelegate

    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text.isEmpty) {
            textView.text = DESCRIPTION_TASK_PLACEHOLDER
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == DESCRIPTION_TASK_PLACEHOLDER){
            textView.text = String()
        }
        textView.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            
            let title = titleTextField.text ?? ""
            let detail = descriptionTextView.text ?? ""
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            let date = dateFormatter.dateFromString(dateTextField.text!)
            
            let urgent = urgentSwitch.on
            
            let complete = task?.completed ?? false
            
            task = Task(title: title, detail: detail, date: date!, urgent: urgent, completed: complete)
        }
    }
    
    // MARK: Auxiliar methods
    
    func setTaskDate(date: NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(date)
    }
    
    func dismissDescriptionKeyboard(){
        descriptionTextView.resignFirstResponder()
    }
    
    func setNavigationBarTitle(title: String) {
        if title.characters.count > NAVIGATION_BAR_TITLE_SIZE {
            navigationItem.title = title.substringToIndex(title.startIndex.advancedBy(NAVIGATION_BAR_TITLE_SIZE)) + " ..."
        }
        else {
            navigationItem.title = title
        }
    }
}
