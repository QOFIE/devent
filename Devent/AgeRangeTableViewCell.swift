//
//  AgeRangeTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 05/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    var minAge: Int?
    var maxAge: Int?
    var user = PFUser.currentUser()
    
    private func loadAgeSettings() {
        if let initialMinAge = user?.objectForKey(USER.minAge) as? Int {
            if let initialMaxAge = user?.objectForKey(USER.maxAge) as? Int {
                self.minAge = initialMinAge
                self.maxAge = initialMaxAge
            }
        } else {
            self.minAge = 22
            self.maxAge = 36
        }
    }
    
    // MARK: CELL LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        loadAgeSettings()
    }
    
    @IBOutlet weak var ageRangeLabel: UILabel! {
        didSet {
            loadAgeSettings()
            ageRangeLabel.text = "\(self.minAge!) - \(self.maxAge!)"
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
            
            if let minValidAge = self.minAge {
                if let maxValidAge = self.maxAge {
                    ageRangeLabel.text = "\(minValidAge) - \(maxValidAge)"
                    rangeSlider.lowerValue = Double(minValidAge - 18) / 47
                    rangeSlider.upperValue = Double(maxValidAge - 18) / 47
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        
        minAge = Int(round(rangeSlider.lowerValue * 47 + 18))
        maxAge = Int(round(rangeSlider.upperValue * 47 + 18))
        
        user?.setObject(minAge!, forKey: USER.minAge)
        user?.setObject(maxAge!, forKey: USER.maxAge)
        user?.saveInBackground()
        
        if rangeSlider.upperValue == 1 {
            ageRangeLabel.text = "\(minAge!) - 65+"
        } else {
            ageRangeLabel.text = "\(minAge!) - \(maxAge!)"
        }
        
        //print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }
}
