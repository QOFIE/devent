//
//  EventCell.swift
//  Devent
//
//  Created by Can Ceran on 15/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventCell: PFTableViewCell {
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    // MARK: ACTIONS
    
    @IBAction func eventDetailsButton(sender: UIButton) {
        // Segue to event details
    }
    
    /*
    override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
    }
    */
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    // MARK: VIEW LIFECYCLE
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    */

}
