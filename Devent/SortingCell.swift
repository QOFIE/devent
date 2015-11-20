//
//  SortingCell.swift
//  Devent
//
//  Created by Can Ceran on 15/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class SortingCell: PFTableViewCell {
    
    // MARK: PROPERTIES
    
    lazy var sortBy: String = SortBy.popularity
    
    // MARK: ACTIONS
    
    @IBAction func sortingSegmentedControl(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: self.sortBy = SortBy.popularity
        case 1: self.sortBy = SortBy.date
        case 2: self.sortBy = SortBy.price
        default: break
        
        }
        
        // Don't forget to set a protocol to notify the View Controller everytime the user touches the segmented control
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
