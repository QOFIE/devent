//
//  ProfileTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 29/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: CONSTANTS
    
    struct CategoryIdentifier {
        static let picture = "ProfilePictureCell"
        static let nameAgeLocation = "NameAgeLocationCell"
        static let about = "AboutCell"
        static let info = "UserInfoCell"
    }
    
    // MARK: PROPERTIES
    
    var user = PFUser.currentUser() {
        didSet {
            if !self.profileDataTable.isEmpty {
                self.profileDataTable.removeAll()
            }
            loadProfileData()
        }
    }
    
    var profileDataTable: [ProfileInfo] = []
    
    var profilePictureImage: UIImage? = UIImage(named: "nah-button-press")
    
    // Cells will be allocated to different cell types based on the ProfileInfo.category, and filled with the ProfileInfo.data
    struct ProfileInfo: CustomStringConvertible {
        var category: String
        var data: ProfileInfoItem
        var description: String {
            return "\(category): \(data)"
        }
    }
    
    // Define the profile info tyes
    enum ProfileInfoItem: CustomStringConvertible {
        case PictureUser(PFUser)
        case NameAgeLocation(String, String)
        case About(String)
        case Work(String)
        case Education(String)
        case OpenTo(String)
        case Height(String)
        case Tags(String)
        case Events(String)
        var description: String {
            switch self {
            case .PictureUser(let user): return user.description
            case .NameAgeLocation(let name, let ageLocation): return "\(name), \(ageLocation)"
            case .About(let about): return about
            case .Work: return "work"
            case .Education: return "education"
            case .OpenTo: return "openTo"
            case .Height: return "height"
            case .Tags: return "tags"
            case .Events: return "events"
            }
        }
    }

    
    // MARK: ACTIONS
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    private func fetchName() -> String {
        var name: String = ""
        if let firstName = user?.objectForKey(USER.firstName) as? String {
            name += "\(firstName)"
        }
        if let lastName = user?.objectForKey(USER.lastName) as? String {
            name += " \(lastName)"
        }
        return name
    }
    
    private func fetchAgeLocation() -> String {
        var ageLocation: String = ""
        if let age = user?.objectForKey(USER.age) as? String {
            ageLocation += "\(age)"
        }
        if let location = user?.objectForKey(USER.location) as? String {
            ageLocation += ", \(location)"
        }
        return ageLocation
    }

    private func loadProfileData() {
        
        // add profile picture (picture MUST exist)
        let pictureItem = ProfileInfo(category: CategoryIdentifier.picture, data: .PictureUser(self.user!))
        profileDataTable.append(pictureItem)
        
        // add name, age, location (name, age and location MUST exist)
        let nameItem = ProfileInfo(category: CategoryIdentifier.nameAgeLocation, data: .NameAgeLocation(fetchName(), fetchAgeLocation()))
        profileDataTable.append(nameItem)
        
        // add about if it exists
        if let about = user?.objectForKey(USER.about) as? String {
            let aboutItem = ProfileInfo(category: CategoryIdentifier.about, data: .About(about))
            profileDataTable.append(aboutItem)
        }
        
        // add work if it exists
        if let work = user?.objectForKey(USER.work) as? String {
            let workItem = ProfileInfo(category: CategoryIdentifier.info, data: .Work(work))
            profileDataTable.append(workItem)
        }
        
        // add education if if exists
        if let education = user?.objectForKey(USER.education) as? String {
            let educationItem = ProfileInfo(category: CategoryIdentifier.info, data: .Education(education))
            profileDataTable.append(educationItem)
        }
        
        // add openTo if it exists
        if let openTo = user?.objectForKey(USER.openTo) as? String {
            let openToItem = ProfileInfo(category: CategoryIdentifier.info, data: ProfileInfoItem.OpenTo(openTo))
            profileDataTable.append(openToItem)
        }
        
        // add height if it exists
        if let height = user?.objectForKey(USER.height) as? String {
            let heightItem = ProfileInfo(category: CategoryIdentifier.info, data: ProfileInfoItem.Height(height))
            profileDataTable.append(heightItem)
        }
        
        // add tags if it exists
        if let tags = user?.objectForKey(USER.tags) as? String {
            let tagsItem = ProfileInfo(category: CategoryIdentifier.info, data: ProfileInfoItem.Tags(tags))
            profileDataTable.append(tagsItem)
        }
        
        // add events (event choices MUST exist in settings)
        // LATER!!!
        
        print("Profile data is loaded to the array.")
        
        
    }
    
    // MARK: VC LIFECYCLE
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: TABLEVIEW DATA SOURCE

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Everything goes under the same section on the profile page, hence hard coded 1 section
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("\(profileDataTable.count)")
        return profileDataTable.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let item = profileDataTable[indexPath.row]
        print("the current item is \(item)")
        
        switch (item.category) {

        case CategoryIdentifier.picture:
            let pictureCell = tableView.dequeueReusableCellWithIdentifier(CategoryIdentifier.picture, forIndexPath: indexPath) as! ProfilePictureTableViewCell
            
            switch item.data {
            case .PictureUser(let pictureUser): pictureCell.user = pictureUser
            default: break
            }
           
            return pictureCell
            
        case CategoryIdentifier.nameAgeLocation:
            let nameAgeLocationCell = tableView.dequeueReusableCellWithIdentifier(CategoryIdentifier.nameAgeLocation, forIndexPath: indexPath) as! UserNameAndAgeTableViewCell
            //let (name, ageLocation) = item.data as! (String, String)
            switch item.data {
            case .NameAgeLocation(let name, let ageLocation):
                nameAgeLocationCell.nameAndLastnameLabel.text = name
                nameAgeLocationCell.locationLabel.text = ageLocation
            default: break
            }
            return nameAgeLocationCell
            
        case CategoryIdentifier.about:
            let aboutCell = tableView.dequeueReusableCellWithIdentifier(CategoryIdentifier.about, forIndexPath: indexPath) as! AboutTableViewCell
            switch item.data {
            case .About(let about): aboutCell.aboutLabel.text = about
            default: break
            }
            return aboutCell
            
        case CategoryIdentifier.info:
            let infoCell = tableView.dequeueReusableCellWithIdentifier(CategoryIdentifier.info, forIndexPath: indexPath) as! UserInfoTableViewCell
            
            switch item.data {
            case .Work(let text): infoCell.userInfoLabel.text = text
            case .Education(let text): infoCell.userInfoLabel.text = text
            case .OpenTo(let text): infoCell.userInfoLabel.text = text
            case .Height(let text): infoCell.userInfoLabel.text = text
            case .Tags(let text): infoCell.userInfoLabel.text = text
            case .Events(let text): infoCell.userInfoLabel.text = text
            default: break
            }
            
            let imageName = item.data.description
            infoCell.infoTypeImageView.image = UIImage(named: imageName)
            
            return infoCell
        
        default: break
            
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if profileDataTable[indexPath.row].category == CategoryIdentifier.picture {
            return tableView.bounds.size.width
        }
        return UITableViewAutomaticDimension
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    
    // MARK: NAVIGATION

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
