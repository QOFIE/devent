//
//  AgeRangeTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 05/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    // MARK: CELL LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var ageRangeLabel: UILabel! {
        didSet {
            ageRangeLabel.text = "22 - 36"
        }
    }
    
    @IBOutlet weak var cellTitleLabel: UILabel! {
        didSet {
            cellTitleLabel.text = "Age Range"
        }
    }
    
    @IBOutlet weak var rangeSliderView: UIView! {
        didSet {
            
            let width = UIScreen.mainScreen().bounds.width
            
            print("Content view bounds is \(contentView.bounds), Window view width is \(width)")
            print("Range slider view bounds is \(rangeSliderView.bounds)")
            let rangeSlider = RangeSlider(frame: rangeSliderView.bounds)
            rangeSliderView.addSubview(rangeSlider)


            rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        
        let minAge = Int(round(rangeSlider.lowerValue * 47 + 18))
        let maxAge = Int(round(rangeSlider.upperValue * 47 + 18))
        
        if rangeSlider.upperValue == 1 {
            ageRangeLabel.text = "\(minAge) - 65+"
        } else {
            ageRangeLabel.text = "\(minAge) - \(maxAge)"
        }
        
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }

}

/* 

private func setConstraintsForSlider(slider: RangeSlider, item: AnyObject) {
    let standardMarginConstant: CGFloat = 8
    let topConstraint = NSLayoutConstraint(
        item: slider,
        attribute: NSLayoutAttribute.TopMargin,
        relatedBy: NSLayoutRelation.Equal,
        toItem: item,
        attribute: NSLayoutAttribute.Bottom,
        multiplier: 1,
        constant: standardMarginConstant)
    let leftConstraint = NSLayoutConstraint(
        item: slider,
        attribute: NSLayoutAttribute.LeadingMargin,
        relatedBy: NSLayoutRelation.Equal,
        toItem: self.contentView,
        attribute: NSLayoutAttribute.LeadingMargin,
        multiplier: 1,
        constant: standardMarginConstant)
    let rightConstraint = NSLayoutConstraint(
        item: slider,
        attribute: NSLayoutAttribute.TrailingMargin,
        relatedBy: NSLayoutRelation.Equal,
        toItem: self.contentView,
        attribute: NSLayoutAttribute.TrailingMargin,
        multiplier: 1,
        constant: standardMarginConstant)
    let constraints = [topConstraint, leftConstraint, rightConstraint]
    slider.addConstraints(constraints)
    NSLayoutConstraint.activateConstraints(constraints)
}
*/
