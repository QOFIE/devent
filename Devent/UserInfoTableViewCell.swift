//
//  UserInfoTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var infoTypeImageView: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
