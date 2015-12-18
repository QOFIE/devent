//
//  MacthesTableViewController.swift
//  Devent
//
//  Created by Erman Sefer on 27/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MacthesTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    var eventId = ""
    var eventNameId = ""
    var byUserId = ""
    var toUserId = ""
    var localStore = [PFObject]()
    var shouldUpdateFromServer:Bool = true
  
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
        self.paginationEnabled = true
        self.objectsPerPage = 10
        
    }
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "MatchedEvent").whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        let query2 = PFQuery(className: "MatchedEvent").whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        let query3 = PFQuery.orQueryWithSubqueries([query, query2])
        query3.orderByAscending("matchedEventName")
        return query3
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery{
        return baseQuery().fromLocalDatastore()
        
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
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MacthesCustomCell!
        if cell == nil {
            cell = MacthesCustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "matchCell")
        }
        
        cell.timeLeftLabel.hidden = true
        cell.progressBar.hidden = true
        
        
        var currentUserName: String = ""
        var otherUserName: String = ""
        
        // Extract values from the PFObject to display in the table cell
        let username = object?["toUser"] as? String
            if (username == PFUser.currentUser()?.objectId) {
                otherUserName = object?["byUserName"] as! String
                currentUserName = object?["toUserName"] as! String
                cell.matchedUserName.text = otherUserName
                if let thumbnail = object?["byUserPicture"] as? PFFile{
                    thumbnail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.matchedEventProfilePicture.image = UIImage(data:imageData!)
                        }
                    })
                }
            } else {
                otherUserName = object?["toUserName"] as! String
                currentUserName = object?["byUserName"] as! String
                cell.matchedUserName.text = otherUserName
                if let thumbnail = object?["toUserPicture"] as? PFFile{
                    thumbnail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.matchedEventProfilePicture.image = UIImage(data:imageData!)
                        }
                    })
                }
        
            }
        

        cell.matchedEventName.text = object?["matchedEventName"] as? String
        
        let date = NSDate()
        let createdDate = object?.updatedAt
        let differenceDate = (24*60*60) - date.timeIntervalSinceDate(createdDate!)
        let differencePercentage = 1 - (differenceDate / (24*60*60))
        let differenceHour = Int(differenceDate) / 3600
        let differenceMinute = (Int(differenceDate) % 3600) / 60
        
        if (cell.payButtonOutlet.titleLabel?.text == "Message") {
        if (differenceDate <= 0.0) {
     
        
        }
        else {
        cell.timeLeftLabel.hidden = false
        cell.progressBar.hidden = false
        cell.timeLeftLabel.text = " \(differenceHour)h" + ", \(differenceMinute)m left."
        cell.progressBar.setProgress(Float(differencePercentage), animated: false)
        }
        }
        
        
        
        let firstPaidUserID = object?["PaidUserId1"]
        let secondPaidUserID = object?["PaidUserId2"]
        
        if PFUser.currentUser()?.objectId != firstPaidUserID as? String && PFUser.currentUser()?.objectId != secondPaidUserID as? String {
            cell.paymentStatusLabel.text = "No one has paid yet :("
            cell.paymentStatusLabel.textColor = UIColor.redColor()
            cell.payButtonOutlet.setTitle("Pay", forState: .Normal)
            if firstPaidUserID != nil {
                cell.paymentStatusLabel.text = "\(otherUserName) has paid. Your move to make it a date!"
                cell.paymentStatusLabel.textColor = UIColor.orangeColor()
            }
        }

        else if PFUser.currentUser()?.objectId == firstPaidUserID as? String && secondPaidUserID as? String == nil {
            cell.paymentStatusLabel.text = "Waiting for \(otherUserName) to pay."
            cell.payButtonOutlet.setTitle("...", forState: .Normal)
            cell.paymentStatusLabel.textColor = UIColor.orangeColor()
            
        } else {
            cell.paymentStatusLabel.text = "You both paid! Say hi!"
            cell.payButtonOutlet.setTitle("Message", forState: .Normal)
            cell.paymentStatusLabel.textColor = UIColor.greenColor()
            
        }
        
        return cell
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        var obj : PFObject? = nil
        if(indexPath!.row < self.objects?.count) {
            obj = self.objects?[indexPath!.row] as? PFObject
        }
        return obj
    }
    
    @IBAction func payOrMessage(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        let event = objectAtIndexPath(hitIndex)
        eventId = (event?.objectId)!
        eventNameId = (event?["matchedEvents"])! as! String
        byUserId = (event?["byUser"])! as! String
        toUserId = (event?["toUser"])! as! String
        
        print(sender.titleLabel!!.text)
        
        if sender.titleLabel?!.text == "Message" {
            performSegueWithIdentifier("MessageSeque", sender: self)
        }
            
        else if sender.titleLabel?!.text == "Pay" {
            performSegueWithIdentifier("paySeque", sender: self)
        }
            
        else {
        }
    }


   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "MessageSeque" {
            let destinationVC = segue.destinationViewController as! UINavigationController
            let messageVC = destinationVC.topViewController as! MessageViewController
            messageVC.groupId = eventId
            
            if (PFUser.currentUser()?.objectId == byUserId) {
                messageVC.byUserIdForPicture = byUserId
                messageVC.toUserIdForPicture = toUserId
            }
            else {
                messageVC.byUserIdForPicture = toUserId
                messageVC.toUserIdForPicture = byUserId
            }
            
        }
            
        else if segue.identifier == "paySeque" {
            let destinationVC = segue.destinationViewController as! UINavigationController
            let payVc = destinationVC.topViewController as! PaymentPageViewController
            payVc.groupId = eventNameId
            payVc.macthedEventObjectId = eventId
            
        }
            
        else {
        }
        
    }
    
    
    @IBAction func unwindToMacthesVC(segue: UIStoryboardSegue) {
        // refresh
        loadObjects()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    
}
