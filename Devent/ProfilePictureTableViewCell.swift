//
//  ProfilePictureTableViewCell.swift
//  Devent
//
//  Created by Can Ceran on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class ProfilePictureTableViewCell: UITableViewCell {
    
    // MARK: PROPOERTIES
    
    var user: PFUser? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: ACTIONS
    
    private func updateUI() {
        if let profilePictureFile = self.user?.objectForKey(USER.profilePicture) as! PFFile? {
            profilePictureFile.getDataInBackgroundWithBlock(){ (imageData: NSData?, error: NSError?) -> Void in
                if let validImageData = imageData {
                    if let profilePictureFetched = UIImage(data: validImageData) {
                        self.profilePictureImageView.image = squareImage(profilePictureFetched)
                        print("Profile picture successfully fetched")
                    }
                }
            }
        }
        else {
            let defaultImage = UIImage(named: "dummy")
            self.profilePictureImageView.image = squareImage(defaultImage!)
        }
    }
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
