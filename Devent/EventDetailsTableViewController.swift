//
//  EventDetailsTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 22/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    // MARK: PROPOERTIES
    
    let featuredEventViewAspectRatio: CGFloat = 600 / 328

    // Object to pass to detail VC
    var event: AnyObject?
    let user = PFUser.currentUser()
    var eventIdArray: [String] = []
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventPopularityLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var otherEventDetailsTextView: UITextView!
    
    // MARK: ACTIONS
    
    @IBAction func yesButton(sender: UIButton) {
        var k = event?.objectForKey("popularity") as? Int
        k = k!+1
        event?.setObject(k, forKey: "popularity")
        event?.saveInBackground()
        
        if(user?.valueForKey("eventIdArray") != nil ){
        eventIdArray = (user?.valueForKey("eventIdArray"))! as! [String]
        }
    let eventId = event?.valueForKey("objectId") as! String
        if(eventIdArray.contains(eventId)) {
    } else {
        eventIdArray.append(eventId)
        }
    
        user?.setObject(eventIdArray, forKey: "eventIdArray")
        
        let relation = user?.relationForKey("userEvent2")
        let PFevent = event as? PFObject
        relation?.addObject(PFevent!)
        user!.saveInBackground()
        createEventMatchbyEventChoice(PFevent!)
    
    }
    @IBAction func noButton(sender: UIButton) {
            let PFevent = event as? PFObject
            relation?.removeObject(PFevent!)
            
            deleteEventMatchbyEventChoice(PFevent!)
            if(user?.valueForKey("eventIdArray") != nil ){
            eventIdArray = (user?.valueForKey("eventIdArray"))! as! [String]
            }
    let eventId = event?.valueForKey("objectId") as! String
            if(eventIdArray.contains(eventId)) {
            let eventToDelete = eventIdArray.indexOf(eventId)
            eventIdArray.removeAtIndex(eventToDelete!)
        } else {
            }
    
            user?.setObject(eventIdArray, forKey: "eventIdArray")
            user!.saveInBackground()
    
    }
    
    private func updateUI() {
        if let event = event as? PFObject {
            if let eventType = event[EVENT.type] as? String {
                eventTypeLabel.text = eventType
            }
            if let eventTitle = event[EVENT.name] as? String {
                eventTitleLabel.text = eventTitle
            }
            if let eventPopularity = event[EVENT.popularity] as? Int {
                eventPopularityLabel.text = "\(eventPopularity)"
            }
            if let eventPrice = event[EVENT.price] as? Int, let currency = event[EVENT.currency] as? String {
                eventPriceLabel.text = "\(eventPrice) \(currency)"
            }
            if let eventAddress = event[EVENT.address] as? String {
                eventAddressLabel.text = eventAddress
            }
            let defaultImage = UIImage(named: "default-event")
            if let eventImage = event[EVENT.image] as? PFFile {
                eventImage.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        if let image = UIImage(data:imageData!) {
                            let width = self.view.bounds.size.width
                            let size = CGSizeMake(width, width / self.featuredEventViewAspectRatio)
                            let resizedImage = squareImage(image)
                            self.eventImageView.image = resizedImage
                        }
                    } else {
                        print("Event image cannot be retrieved from the network")
                    }
                }
            } else {
                self.eventImageView.image = defaultImage
            }
            
            if let eventDate = event[EVENT.date] as? NSDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .MediumStyle
                dateFormatter.timeStyle = .ShortStyle
                let date = dateFormatter.stringFromDate(eventDate)
                eventDateLabel.text = date
            }
        }
    }

    // MARK: TABLEVIEW METHODS
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let width = self.view.bounds.size.width
        switch indexPath.row {
        case 0:
            return width / self.featuredEventViewAspectRatio
        case 4:
            return 74
        default:
            return UITableViewAutomaticDimension
        }

    }
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    */
    
    // MARK: VC LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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
