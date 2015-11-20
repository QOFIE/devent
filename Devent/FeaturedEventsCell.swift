//
//  FeaturedEventsCell.swift
//  Devent
//
//  Created by Can Ceran on 15/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class FeaturedEventsCell: PFTableViewCell {
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var featuredEventImageView: UIImageView!
    
    @IBAction func pageControl(sender: UIPageControl) {
    }
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    // MARK: ACTIONS
    
    
    
    
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
