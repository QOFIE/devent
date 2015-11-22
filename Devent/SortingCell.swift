//
//  SortingCell.swift
//  Devent
//
//  Created by Can Ceran on 15/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

protocol SortingCellDelegate {
    var sortType: String? { get set }
    func getSortType (sender: PFTableViewCell) -> String
}

class SortingCell: PFTableViewCell {
    
    // MARK: PROPERTIES
    
    var delegate: SortingCellDelegate?
    
    // MARK: ACTIONS
    
    @IBAction func sortingSegmentedControl(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.delegate?.sortType = SortBy.popularity
            
        case 1:
            self.delegate?.sortType = SortBy.date
            
        case 2:
            self.delegate?.sortType = SortBy.price
            
        default: break
            
        }
        //print("Sorting delegate is \(self.delegate?.sortType)")
        self.delegate?.getSortType(self)
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
