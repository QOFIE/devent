//
//  MyEventsTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 03/12/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MyEventsTableViewController: PFQueryTableViewController {
    
    // MARK: PROPERTIES
    
    var selectedEvent: AnyObject?
    
    
    
    // MARK: ACTIONS
    
    
    
    
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
        let relation = user?.relationForKey("userEvent2")
        var query = relation?.query()
        query!.orderByAscending("Name")
        return query!
    }
    
    // MARK: TABLEVIEW METHODS
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell: PFTableViewCell?
        cell = EventCell(style: UITableViewCellStyle.Default, reuseIdentifier: EventTableViewCellIdentifier.event)
        if let eventCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.event) as? EventCell {
            if let eventName = object?[EVENT.name] as? String {
                eventCell.eventTitleLabel.text = eventName
                //print("Event name is: \(eventName)")
            }
            if let eventDate = object?[EVENT.date] as? String {
                //print("Event date is: \(eventDate)")
                eventCell.eventDateLabel.text = eventDate
            }
            if let eventAddress = object?[EVENT.address] as? String {
                eventCell.eventLocationLabel.text = eventAddress
                //print("Event is at: \(eventAddress)")
            }
            let defaultImage = UIImage(named: "event")
            if let eventImage = object?[EVENT.image] as? PFFile {
                eventImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let squaredImage = squareImage(UIImage(data:imageData!)!)
                        eventCell.eventImageView.image = squaredImage
                    } else {
                        print("Event image cannot be retrieved from the network")
                    }
                }
            } else {
                eventCell.eventImageView.image = defaultImage
            }
            return eventCell
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let eventToPass = objectAtIndexPath(indexPath) {
            selectedEvent = eventToPass
        }
        performSegueWithIdentifier("MyEventDetailsSegue", sender: self.navigationController)
    }
    
    // MARK: VC LIFECYCLE
    
    override func viewWillAppear(animated: Bool) {
        self.loadObjects()
    }
    
    // MARK: NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let edvc = segue.destinationViewController as? EventDetailsTableViewController {
            if (selectedEvent == nil) {
                let event = sender
                edvc.event = event
            }
            else {
                if let event = selectedEvent {
                    edvc.event = event
                    print ("set the event")
                }
            }
        }
    }
}
