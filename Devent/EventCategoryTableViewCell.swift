//
//  EventCategoryTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 28/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var eventCategoryImageView: UIImageView!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
