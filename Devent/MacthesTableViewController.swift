//
//  MacthesTableViewController.swift
//  Devent
//
//  Created by Erman Sefer on 27/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MacthesTableViewController: PFQueryTableViewController {

    var eventId = ""
    
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
       
        var query2 = PFQuery(className: "MatchedEvent")
            .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        
        var query3 = PFQuery.orQueryWithSubqueries([query, query2])
        query3.orderByAscending("matchedEvents")
        
        return query3
        
    }
    
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MacthesCustomCell!
        if cell == nil {
            cell = MacthesCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "matchCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        
        if var username = object?["toUser"] as? String {
            
            if (username == PFUser.currentUser()?.objectId) {
            username = object?["byUser"] as! String
            }
            
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

    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        var obj : PFObject? = nil
        if(indexPath!.row < self.objects?.count) {
            obj = self.objects?[indexPath!.row] as! PFObject
        }
        return obj
    }
    
    @IBAction func goToMessages(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let event = objectAtIndexPath(hitIndex)
        eventId = (event?.objectId)!
        performSegueWithIdentifier("MessageSeque", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MessageSeque" {
                let destinationVC = segue.destinationViewController as! MessageViewController
                destinationVC.groupId = eventId
            
        }
    }

}
