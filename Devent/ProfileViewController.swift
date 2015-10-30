//
//  ProfileViewController.swift
//  Devent
//
//  Created by Can Ceran on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var profilePicture: UIImageView! {
        didSet {
            profilePicture.contentMode = .Redraw
        }
    }
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    var user = PFUser.currentUser()
    
    // MARK: ACTIONS
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logOutSeque", sender: self)
    }
    
    private func fetchNameAndAge() -> String {
        var nameAndAgeString: String = ""
        if let firstName = user?.objectForKey(USER.firstName) as? String {
            nameAndAgeString += "\(firstName)"
        }
        if let lastName = user?.objectForKey(USER.lastName) as? String {
            nameAndAgeString += " \(lastName)"
        }
        if let age = user?.objectForKey(USER.age) as? String {
            nameAndAgeString += ", \(age)"
        }
        return nameAndAgeString
    }
    
    private func fetchProfilePicture() {
        if let profilePictureFile = user?.objectForKey(USER.profilePicture) as! PFFile? {
            profilePictureFile.getDataInBackgroundWithBlock(){ (imageData: NSData?, error: NSError?) -> Void in
                if let validImageData = imageData {
                    if let profilePictureFetched = UIImage(data: validImageData) {
                        print("Profile picture successfully fetched")
                        self.profilePicture.image = squareImage(profilePictureFetched)
                    }
                }
            }
        }
    }
    
    // MARK: CONSTANTS
    
    struct USER {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let age = "userAge"
        static let profilePicture = "profilePicture"
        static let location = "location"
        static let about = "about"
    }
    
    // MARK: VC LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        eventMatch()
        // Set Name and Age
        nameAgeLabel.text = fetchNameAndAge()
        
        // Set Profile Picture
        fetchProfilePicture()
        
        // Set User Location (City)
        if let location = user?.objectForKey(USER.location) as? String {
            cityLabel.text = location
        } else {
            //cityLabel.hidden = true
            cityLabel.text = "Istanbul"
        }
        
        // Set About Info
        if let about = user?.objectForKey(USER.about) as? String {
            aboutLabel.text = about
        } else {
            //aboutLabel.hidden = true
            aboutLabel.text = "In a storyboard-based application, you will often want to do a little preparation before navigation"
        }

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
