//
//  Styles.swift
//  Priority Task
//
//  Created by Jose Manuel Márquez Pavón on 18/7/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//
import UIKit

// MARK: App Colors

struct AppColor {
    static let blue = UIColor(hue: 212/360, saturation: 67/100, brightness: 89/100, alpha: 1)
    static let transparentBlue = UIColor(hue: 212/360, saturation: 67/100, brightness: 89/100, alpha: 0.3)
    static let golden = UIColor(hue: 39/360, saturation: 100/100, brightness: 70/100, alpha: 1)
    static let transparentGolden = UIColor(hue: 39/360, saturation: 100/100, brightness: 70/100, alpha: 0.3)
    static let gray = UIColor(hue: 285/360, saturation: 0, brightness: 61/100, alpha: 1)
}

// MARK: Views

extension UINavigationBar {
    
    public override func awakeFromNib() {
        self.tintColor = UIColor.whiteColor()
        self.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.barTintColor = AppColor.blue
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

