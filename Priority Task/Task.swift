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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    
    // MARK: Properties
    
    var title: String
    var detail: String
    var date: Date
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
    
    init?(title: String, detail: String?, date: Date, urgent: Bool, completed: Bool) {
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
    
    convenience init?(title: String, detail: String?, date: Date, urgent: Bool) {
        self.init(title: title, detail: detail, date: date, urgent: urgent, completed: false)
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        let detail = aDecoder.decodeObject(forKey: PropertyKey.detailKey) as! String
        let date = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as! Date
        let urgent = aDecoder.decodeBool(forKey: PropertyKey.urgentKey)
        let completed = aDecoder.decodeBool(forKey: PropertyKey.completedKey)
        
        self.init(title: title, detail: detail, date: date, urgent: urgent, completed: completed)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.titleKey)
        aCoder.encode(detail, forKey: PropertyKey.detailKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        aCoder.encode(urgent, forKey: PropertyKey.urgentKey)
        aCoder.encode(completed, forKey: PropertyKey.completedKey)
    }
}
