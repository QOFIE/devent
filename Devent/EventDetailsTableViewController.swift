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
    
    var event: AnyObject?
    
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
    }
    @IBAction func noButton(sender: UIButton) {
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
        }
    }

    // MARK: TABLEVIEW METHODS
    
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
