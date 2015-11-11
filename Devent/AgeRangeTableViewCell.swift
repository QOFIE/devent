//
//  AgeRangeTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 05/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {
    
    
    // MARK: CONSTANTS
    let defaultMargin: CGFloat = 16
    let minAgeAllowed: Int = 18
    let maxAgeAllowed: Int = 55
    
    // MARK: PROPOERTIES
    var minAge: Int?
    var maxAge: Int?
    var user = PFUser.currentUser()

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
            
            let width = UIScreen.mainScreen().bounds.width - (2 * defaultMargin)
            let frame = CGRect(x: defaultMargin / 2, y: 0.0, width: width, height: rangeSliderView.bounds.size.height)
            
            print("Content view bounds is \(contentView.bounds), Window view width is \(width)")
            print("Range slider view bounds is \(rangeSliderView.bounds)")
            
            let rangeSlider = RangeSlider(frame: frame)
            rangeSliderView.addSubview(rangeSlider)
            rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
            
            if let minValidAge = self.minAge {
                if let maxValidAge = self.maxAge {
                    ageRangeLabel.text = "\(minValidAge) - \(maxValidAge)"
                    rangeSlider.lowerValue = ageConverterForSlider(minValidAge)
                    rangeSlider.upperValue = ageConverterForSlider(maxValidAge)
                }
            }
        }
    }
    
    // MARK: ACTIONS
    
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
    
    private func ageConverterForSlider (age: Int) -> Double {
        // Min and Max ages are in the rage of 0 to 1 in RangeSlider.swift. Therefore real age must be converted accordingly.
        let convertedAge = Double(age - minAgeAllowed) / Double(maxAgeAllowed - minAgeAllowed)
        return convertedAge
    }
    
    private func ageConverterFromSlider (slider: Double) -> Int {
        let age = Int(round(slider * Double(maxAgeAllowed - minAgeAllowed) + Double(minAgeAllowed)))
        return age
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        
        minAge = ageConverterFromSlider(rangeSlider.lowerValue)
        maxAge = ageConverterFromSlider(rangeSlider.upperValue)
        
        // Saving the slider settings to the database immediately - NEEDS TO CHANGE WHEN MOVING TO A PROPER MVC MODEL. TRY USING PROTOCOLS
        user?.setObject(minAge!, forKey: USER.minAge)
        user?.setObject(maxAge!, forKey: USER.maxAge)
        user?.saveInBackground()
        
        if rangeSlider.upperValue == 1 {
            ageRangeLabel.text = "\(minAge!) - \(maxAgeAllowed)+"
        } else {
            ageRangeLabel.text = "\(minAge!) - \(maxAge!)"
        }
        //print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
    }
    
    // MARK: CELL LIFECYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadAgeSettings()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
