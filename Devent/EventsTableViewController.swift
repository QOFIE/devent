//
//  EventsTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 22/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventsTableViewController: PFQueryTableViewController, SortingCellDelegate {
    
    // MARK: PROPOERTIES
    
    // Load featured events separetely into an array (there are only 5 of them!)
    var featuredEvents: [PFObject]?
    var sortType: String?
    var selectedEvent: AnyObject?
    var localStore = [PFObject]()
    var shouldUpdateFromServer:Bool = true
    
    // MARK: ACTIONS
    
    // Define the query that will provide the data for the table view
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "Events")
        query.whereKey(EVENT.featured, equalTo: false)
        if let sortBy = sortType {
            return query.orderByAscending(sortBy)
        } else {
           return query.orderByAscending(EVENT.popularity)
        }
    }
    
    override func queryForTable() -> PFQuery {
        return self.baseQuery().fromLocalDatastore()
    }
    
    func refreshLocalDataStoreFromServer() {
        
        self.baseQuery().findObjectsInBackgroundWithBlock({
            object, error in
            
            PFObject.unpinAllInBackground(self.objects as? [PFObject], block: { (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    
                    for action in object! {
                        self.localStore.append(action) }
                    
                    PFObject.pinAllInBackground(self.localStore, block: { (succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
                            // Once we've updated the local datastore, update the view with local datastore
                            self.shouldUpdateFromServer = false
                            self.loadObjects()
                        } else {
                            print("Failed to pin objects")
                        }
                    })
                    
                }
                else {
                    print("Failed to unpin objects")
                }
            })
        })
        
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        // If we just updated from the server, do nothing, otherwise update from server.
        if self.shouldUpdateFromServer {
            self.refreshLocalDataStoreFromServer()
        } else {
            self.shouldUpdateFromServer = true
        }
    }

    func findFeaturedEvents() -> [PFObject]? {
        var featuredEventsArray: [PFObject]?
        let query = PFQuery(className: "Events").whereKey(EVENT.featured, equalTo: true)
        
        if (Reachability.isConnectedToNetwork() == false) {
        query.fromLocalDatastore()
        }
        
        query.findObjectsInBackgroundWithBlock {
            (events: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(events!.count) featured events!")
                // Do something with the found objects
                PFObject.unpinAllInBackground(self.objects as? [PFObject])
                PFObject.pinAllInBackground(events)
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
    
    func getSortType (sender: PFTableViewCell) -> String {
        var sorting = SortBy.popularity
        if self.sortType != nil {
            sorting = self.sortType!
            //print("The table needs to be sorted by \(sorting)")
            loadObjects()
            self.tableView.reloadData()
        }
        return sorting
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
                sortingCell.delegate = self
                return sortingCell
            }
        }
            
        else {
            if let eventCell = tableView.dequeueReusableCellWithIdentifier(EventTableViewCellIdentifier.event) as? EventCell {
                // Extract values from the PFObject to display in the table cell
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
                let defaultImage = UIImage(named: "default-event")
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
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 1 {
            print("in the selection function")
            if let eventToPass = objectAtIndexPath(indexPath) {
                selectedEvent = eventToPass
            }
            performSegueWithIdentifier("EventDetailsSegue", sender: self.navigationController)
            print("end of the selection function")
        }
    }
    
    
    // MARK: VC LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.featuredEvents = findFeaturedEvents()
        self.sortType = SortBy.popularity
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
    
    
    // MARK: NAVIGATION

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let edvc = segue.destinationViewController as? EventDetailsTableViewController {
        
            print("obtained the right vc")
            print(selectedEvent?.objectId)
            if let event = selectedEvent {
                edvc.event = event
                print ("set the event")
            }
            else {print("patates")}
        }
    }

}
