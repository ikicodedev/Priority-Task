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
        
        self.completeLabel.isHidden = true
        
        // Description placeholder
        descriptionTextView.delegate = self
        if (descriptionTextView.text.isEmpty) {
            textViewDidEndEditing(descriptionTextView)
        }
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissDescriptionKeyboard))
        self.view.addGestureRecognizer(tapDismiss)
        
        self.setTaskDate(Date())
        
        if let task = task {
            setNavigationBarTitle(task.title)
            titleTextField.text = task.title
            descriptionTextView.text = task.detail
            self.setTaskDate(task.date as Date)
            urgentSwitch.isOn = task.urgent
            
            if task.completed {
                self.completeLabel.isHidden = false
            }
        }
        
        // Enable the Save button only if the title field is valid.
        checkValidTaskName()
    }
    
    // MARK: Actions
    
    @IBAction func dateEditing(_ sender: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.timeZone = TimeZone.autoupdatingCurrent
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        if let dateText = dateTextField.text , !dateText.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            datePickerView.date = dateFormatter.date(from: dateText)!
        }
        
        let doneButton = UIBarButtonItem(title: "Hecho", style: .done, target: self, action: #selector(doneDateButton))
        doneButton.tintColor = AppColor.blue
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
    }
    
    func doneDateButton(_ sender:UIButton)
    {
        dateTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let currentDate = Date()
        
        if (Calendar.current as NSCalendar).compare(currentDate, to:sender.date, toUnitGranularity:NSCalendar.Unit.day) == ComparisonResult.orderedDescending {
            
            let alert = UIAlertController(title: "Atención", message: "La fecha tiene que ser la de hoy o una futura", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            self.setTaskDate(sender.date)
        }
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkValidTaskName()
        
        if let title = textField.text {
            
            setNavigationBarTitle(title)
            
        }
    }
    
    func checkValidTaskName() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? String()
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: UITextViewDelegate

    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty) {
            textView.text = DESCRIPTION_TASK_PLACEHOLDER
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == DESCRIPTION_TASK_PLACEHOLDER){
            textView.text = String()
        }
        textView.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as! UIBarButtonItem === saveButton {
            
            let title = titleTextField.text ?? ""
            let detail = descriptionTextView.text ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.none
            let date = dateFormatter.date(from: dateTextField.text!)
            
            let urgent = urgentSwitch.isOn
            
            let complete = task?.completed ?? false
            
            task = Task(title: title, detail: detail, date: date!, urgent: urgent, completed: complete)
        }
    }
    
    // MARK: Auxiliar methods
    
    func setTaskDate(_ date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: date)
    }
    
    func dismissDescriptionKeyboard(){
        descriptionTextView.resignFirstResponder()
    }
    
    func setNavigationBarTitle(_ title: String) {
        if title.characters.count > NAVIGATION_BAR_TITLE_SIZE {
            navigationItem.title = title.substring(to: title.characters.index(title.startIndex, offsetBy: NAVIGATION_BAR_TITLE_SIZE)) + " ..."
        }
        else {
            navigationItem.title = title
        }
    }
}
