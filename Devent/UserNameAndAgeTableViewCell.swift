//
//  UserNameAndAgeTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class UserNameAndAgeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameAndLastnameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
