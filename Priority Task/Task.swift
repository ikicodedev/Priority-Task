//
//  Task.swift
//  Priority Task
//
//  Created by Jose Manuel Márquez Pavón on 20/7/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//

import UIKit

class Task: NSObject, NSCoding {
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("tasks")
    
    
    // MARK: Properties
    
    var title: String
    var detail: String
    var date: NSDate
    var urgent: Bool
    var completed: Bool
    
    struct PropertyKey {
        static let titleKey = "title"
        static let detailKey = "detail"
        static let dateKey = "date"
        static let urgentKey = "urgent"
        static let completedKey = "completed"
    }
    
    // MARK: Initialization
    
    init?(title: String, detail: String?, date: NSDate, urgent: Bool, completed: Bool) {
        self.title = title
        self.detail = detail ?? String()
        self.date = date
        self.urgent = urgent
        self.completed = completed
        
        super.init()
        
        // Initialization should fail if there is no title
        if title.isEmpty {
            return nil
        }
    }
    
    convenience init?(title: String, detail: String?, date: NSDate, urgent: Bool) {
        self.init(title: title, detail: detail, date: date, urgent: urgent, completed: false)
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let detail = aDecoder.decodeObjectForKey(PropertyKey.detailKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let urgent = aDecoder.decodeBoolForKey(PropertyKey.urgentKey)
        let completed = aDecoder.decodeBoolForKey(PropertyKey.completedKey)
        
        self.init(title: title, detail: detail, date: date, urgent: urgent, completed: completed)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(detail, forKey: PropertyKey.detailKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeBool(urgent, forKey: PropertyKey.urgentKey)
        aCoder.encodeBool(completed, forKey: PropertyKey.completedKey)
    }
}
