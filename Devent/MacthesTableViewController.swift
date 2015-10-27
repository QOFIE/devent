//
//  MacthesTableViewController.swift
//  Devent
//
//  Created by Erman Sefer on 27/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MacthesTableViewController: PFQueryTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        eventMatch()

    }

    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "MatchedEvent"
        self.textKey = "matchedEvents"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        
        var query = PFQuery(className: "MatchedEvent")
            .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        query.orderByAscending("matchedEvents")
        return query
    }
    
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MacthesCustomCell!
        if cell == nil {
            cell = MacthesCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "matchCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        
        if let username = object?["toUser"] as? String {
            
            var otherUserArray = [PFObject]()
            let queryUser = PFQuery(className: "_User")
                .whereKey("objectId", equalTo: username)
            
            do {
                otherUserArray = try queryUser.findObjects()
                
            }
            catch {
                
            }
            
            cell.matchedUserName.text = otherUserArray[0]["firstName"] as! String
        }
        
        
        if let eventName = object?["matchedEvents"] as? String {
            
            var otherUserArray1 = [PFObject]()
            let queryUser1 = PFQuery(className: "Events")
                .whereKey("objectId", equalTo: eventName)
            
            do {
                otherUserArray1 = try queryUser1.findObjects()
                
            }
            catch {
                
            }
            
            
            cell.matchedEventName.text = otherUserArray1[0]["Name"] as! String
        }
 
        
        return cell
    }

   

}
