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
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        let lineWidth: CGFloat = 1.0
        let startingPoint = CGPointMake(self.bounds.minX, self.bounds.minY)
        let endingPoint = CGPointMake(self.bounds.maxX, self.bounds.minY)
        var linePath = UIBezierPath()
        linePath.moveToPoint(startingPoint)
        linePath.addLineToPoint(endingPoint)
        linePath.lineWidth = lineWidth
        UIColor.lightGrayColor().setStroke()
        linePath.stroke()

    }
    
    
    // MARK: VIEW LIFECYCLE
    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    */

}
