//
//  NewEventTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 15/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class NewEventTableViewController: PFQueryTableViewController {
    
    
    // MARK: PROPOERTIES
    
    // Load featured events separetely into an array (there are only 5 of them!)
    var featuredEvents: [PFObject]?
    
    // MARK: ACTIONS
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Events")
        query.whereKey(EVENT.featured, equalTo: false)
        query.orderByAscending(EVENT.popularity)
        return query
    }
    
    private func queryForTableOrderedBy(order: String) -> PFQuery {
        let query = queryForTable()
        query.orderByAscending(order)
        return query
    }
    
    private func findFeaturedEvents() -> [PFObject]? {
        var featuredEventsArray: [PFObject]?
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (events: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(events!.count) featured events!")
                // Do something with the found objects
                if events != nil {
                    featuredEventsArray = events!
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        return featuredEventsArray
    }
    
    /*
    override func objectsDidLoad(error: NSError?) {
        // Do any setup when table query objects load
    }
    */
    
    
    // MARK: TABLEVIEW METHODS
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {

        var cell: PFTableViewCell?
        
        if indexPath.row == 0 {
            print("Index 0")
            if let featuredEventsCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.featured) as? FeaturedEventsCell {
                return featuredEventsCell
            }
        }
        
        else if indexPath.row == 1 {
            print("Index 1")
            if let sortingCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.sorting) as? SortingCell {
                print("Sorting cell is executed.")
                return sortingCell
            }
        }
        
        else {
            if let eventCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.event) as? EventCell {
                // Extract values from the PFObject to display in the table cell
                if let eventName = object?[EVENT.name] as? String {
                    eventCell.eventTitleLabel.text = eventName
                    print("Event name is: \(eventName)")
                }
                if let eventDate = object?[EVENT.date] as? String {
                    print("Event date is: \(eventDate)")
                    eventCell.eventDateLabel.text = eventDate
                }
                if let eventAddress = object?[EVENT.address] as? String {
                    eventCell.eventLocationLabel.text = eventAddress
                    print("Event is at: \(eventAddress)")
                }
                let defaultImage = UIImage(named: "default-event")
                if let eventImage = object?[EVENT.image] as? PFFile {
                    eventImage.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            eventCell.eventImageView.image = UIImage(data:imageData!)
                        } else {
                            print("Event image cannot be retrieved from the network")
                        }
                    }
                } else {
                    eventCell.eventImageView.image = defaultImage
                }
                return eventCell
            }
        }
        
        return cell!
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        var obj: PFObject?
        if let index = indexPath?.row, let count = self.objects?.count {
            
            if (index > 1) && (index < count + 2) {
                obj = self.objects?[(index - 2)] as? PFObject
            }
            
        }

        return obj
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.objects?.count)! + 2)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.view.bounds.size.width
        let featuredEventImageAspectRatio: CGFloat = 600 / 328
        switch indexPath.row {
        case 0:
            return width / featuredEventImageAspectRatio
        case 1:
            return UITableViewAutomaticDimension
        default:
            return 80
        }
    }
    
    
    // MARK: VC LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuredEvents = findFeaturedEvents()
    }
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Events"
        self.textKey = EVENT.name
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        
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
