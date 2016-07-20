//
//  TaskViewController.swift
//  Priority Task
//
//  Created by Jose Manuel Márquez Pavón on 18/7/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    // MARK: Actions
    @IBAction func dateEditing(sender: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        if let dateText = dateTextField.text where !dateText.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            datePickerView.date = dateFormatter.dateFromString(dateText)!
        }
        
        let doneButton = UIBarButtonItem(title: "Ok", style: .Done, target: self, action: #selector(doneDateButton))
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
        self.setTaskDate(sender.date)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        self.setTaskDate(NSDate())
    }
    
    // MARK: Auxiliar methods
    func setTaskDate(date: NSDate){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateTextField.text = dateFormatter.stringFromDate(date)
    }
}
