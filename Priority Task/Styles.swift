//
//  Styles.swift
//  Priority Task
//
//  Created by Jose Manuel Márquez Pavón on 18/7/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//
import UIKit

extension UINavigationBar {
    
    public override func awakeFromNib() {
        self.tintColor = UIColor.whiteColor()
        self.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.barTintColor = UIColor(hue: 212/360, saturation: 67/100, brightness: 89/100, alpha: 1)
    }
}

extension UITextView {
    
    public override func awakeFromNib() {
        self.tintColor = UIColor.lightGrayColor()
        self.textColor = UIColor.lightGrayColor()
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 6;
        self.clipsToBounds = true;
    }
}

extension UITextField {
    
    public override func awakeFromNib() {
        self.tintColor = UIColor.lightGrayColor()
        self.textColor = UIColor.lightGrayColor()
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.layer.cornerRadius = 6;
        self.clipsToBounds = true;
    }
}

