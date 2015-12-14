//
//  DiscoverProfilePage.swift
//  Devent
//
//  Created by Erman Sefer on 27/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

import UIKit

class DiscoverProfilePage: UITableViewController {
    
    var user2 = PFUser()
    var user2Id: String = ""
    
    // MARK: CONSTANTS
    
    struct CategoryIdentifier {
        static let picture = "ProfilePictureCell"
        static let nameAgeLocation = "NameAgeLocationCell"
        static let about = "AboutCell"
        static let info = "UserInfoCell"
    }
    
    // MARK: PROPERTIES
    
    var profileDataTable: [ProfileInfo] = []
    
    var profilePictureImage: UIImage!
    
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
    
    
    private func fetchName() -> String {
        var name: String = ""
        if let firstName = user2.objectForKey(USER.firstName) as? String {
            name += "\(firstName)"
        }
        if let lastName = user2.objectForKey(USER.lastName) as? String {
            name += ""
        }
        return name
    }
    
    private func fetchAgeLocation() -> String {
        var ageLocation: String = ""
        if let age = user2.objectForKey(USER.age) as? String {
            ageLocation += "\(age)"
        }
        if let location = user2.objectForKey(USER.location) as? String {
            ageLocation += ", \(location)"
        }
        return ageLocation
    }
    
    private func loadProfileData() {
        
        if !self.profileDataTable.isEmpty {
            self.profileDataTable.removeAll()
        }
        
        // add profile picture (picture MUST exist)
        let pictureItem = ProfileInfo(category: CategoryIdentifier.picture, data: .PictureUser(self.user2))
        profileDataTable.append(pictureItem)
        
        // add name, age, location (name, age and location MUST exist)
        let nameItem = ProfileInfo(category: CategoryIdentifier.nameAgeLocation, data: .NameAgeLocation(fetchName(), fetchAgeLocation()))
        profileDataTable.append(nameItem)
        print("\(nameItem.data.description)")
        
        // add about if it exists
        if let about = user2.objectForKey(USER.about) as? String {
            let aboutItem = ProfileInfo(category: CategoryIdentifier.about, data: .About(about))
            profileDataTable.append(aboutItem)
        }
        
        // add work if it exists
        if let work = user2.objectForKey(USER.work) as? String {
            let workItem = ProfileInfo(category: CategoryIdentifier.info, data: .Work(work))
            profileDataTable.append(workItem)
        }
        
        // add education if if exists
        if let education = user2.objectForKey(USER.education) as? String {
            let educationItem = ProfileInfo(category: CategoryIdentifier.info, data: .Education(education))
            profileDataTable.append(educationItem)
        }
        
        // add openTo if it exists
        if let openTo = user2.objectForKey(USER.openTo) as? [String] {
            if openTo.count > 0 {
                var openToString: String = ""
                for (var i=0; i<openTo.count; i++) {
                    if i == 0 {
                        openToString += "\(openTo[i])"
                    } else {
                        openToString += ", \(openTo[i])"
                    }
                    
                }
                let openToItem = ProfileInfo(category: CategoryIdentifier.info, data: ProfileInfoItem.OpenTo(openToString))
                profileDataTable.append(openToItem)
            }
        }
        
        // add height if it exists
        if let height = user2.objectForKey(USER.height) as? String {
            let heightItem = ProfileInfo(category: CategoryIdentifier.info, data: ProfileInfoItem.Height(height))
            profileDataTable.append(heightItem)
        }
        
        // add tags if it exists
        if let tags = user2.objectForKey(USER.tags) as? String {
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
        print(user2.objectId)
        loadProfileData()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadProfileData()
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
        print("View will appear executed")
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
    
    
    
}
