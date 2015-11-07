//
//  EventViewController.swift
//  Devent
//
//  Created by Erman Sefer on 22/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventViewController: PFQueryTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
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
            var query = PFQuery(className: "Events")
            query.orderByAscending("Name")
            return query
        }
    
    


//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell

 override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomCell!
    if cell == nil {
        cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
    }
    
    // Extract values from the PFObject to display in the table cell
    
    if let nameEnglish = object?["Name"] as? String {
        cell.eventName.text = nameEnglish
    }
    
    // Display flag image
    var initialThumbnail = UIImage(named: "question")
    cell.eventPicture.image = initialThumbnail
    if let thumbnail = object?["Picture"] as? PFFile{
        thumbnail.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                cell.eventPicture.image = UIImage(data:imageData!)
            }
        })

        
    }
    
    
    return cell
}
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        var obj : PFObject? = nil
        if(indexPath!.row < self.objects?.count) {
        obj = self.objects?[indexPath!.row] as! PFObject
    }
    return obj
    }
    
    @IBAction func eventChange(sender: UISwitch) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let event = objectAtIndexPath(hitIndex)
        let user = PFUser.currentUser()
        let relation = user?.relationForKey("userEvents")
        
        if(sender.on) {
        relation?.addObject(event!)
        createEventMatchbyEventChoice(event!)
        }
        
        else {
        relation?.removeObject(event!)
        deleteEventMatchbyEventChoice(event!)
            
        }
        user?.saveInBackground()
        
    }
    
    @IBAction func moveToNext(sender: UIButton) {
        self.performSegueWithIdentifier("lastSeque", sender: self)
        
    }
    
    
    
}

