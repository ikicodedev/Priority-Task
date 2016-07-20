//
//  TaskTableViewCell.swift
//  Priority Task
//
//  Created by Markez Soft on 31/3/16.
//  Copyright © 2016 Markez Soft. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var taskColorMark: UIView!

    @IBOutlet weak var contentTaskView: UIView!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    
    // MARK: UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
