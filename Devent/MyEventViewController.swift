//
//  MyEventViewController.swift
//  Devent
//
//  Created by Erman Sefer on 23/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MyEventViewController: PFQueryTableViewController {

    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Events"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        
        let user = PFUser.currentUser()
        let relation = user?.relationForKey("userEvents")
        var query = relation?.query()
        query!.orderByAscending("Name")
        return query!
    }
    
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell2") as! MyCustomCell!
        if cell == nil {
            cell = MyCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell2")
        }
        
        // Extract values from the PFObject to display in the table cell
        
        if let nameEnglish = object?["Name"] as? String {
            cell.MyEventLabel.text = nameEnglish
        }
        
        // Display flag image
        var initialThumbnail = UIImage(named: "question")
        cell.MyEventPicture.image = initialThumbnail
        if let thumbnail = object?["Picture"] as? PFFile{
            thumbnail.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.MyEventPicture.image = UIImage(data:imageData!)
                }
            })
        
        }
        
        
        return cell
    }


}
