//
//  MacthesTableViewController.swift
//  Devent
//
//  Created by Erman Sefer on 27/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class MacthesTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var eventId = ""
    var eventNameId = ""
    var byUserId = ""
    var toUserId = ""
    var localStore = [PFObject]()
    var shouldUpdateFromServer:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
     
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
        self.paginationEnabled = true
        self.objectsPerPage = 10
        
    }
    
    func baseQuery() -> PFQuery {
        let query = PFQuery(className: "MatchedEvent").whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        let query2 = PFQuery(className: "MatchedEvent").whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        
        if searchBar.text == "" {
            let query3 = PFQuery.orQueryWithSubqueries([query, query2])
            query3.orderByAscending("matchedEventName")
            return query3 }
            
        else {
            let query3 = PFQuery.orQueryWithSubqueries([query, query2]).whereKey("matchedEventName", containsString: searchBar.text)
            query3.orderByAscending("matchedEventName")
            return query3 }
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
        
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.grayColor().CGColor
        
        // Extract values from the PFObject to display in the table cell
    
        let username = object?["toUser"] as? String
            
            if (username == PFUser.currentUser()?.objectId) {
                cell.matchedUserName.text = object?["byUserName"] as? String
                if let thumbnail = object?["byUserPicture"] as? PFFile{
                    thumbnail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            cell.matchedEventProfilePicture.image = UIImage(data:imageData!)
                        }
                    })
                }
            } else {
                cell.matchedUserName.text = object?["toUserName"] as? String
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
        
        if PFUser.currentUser()?.objectId != object?["PaidUserId1"] as? String && PFUser.currentUser()?.objectId != object?["PaidUserId2"] as? String{
            
            cell.payButtonOutlet.setTitle("Pay", forState: .Normal)
            
        } else if PFUser.currentUser()?.objectId == object?["PaidUserId1"] as? String && object?["PaidUserId2"] as? String == nil {
            
            cell.payButtonOutlet.setTitle("Paid", forState: .Normal)
            
        } else {
            
            cell.payButtonOutlet.setTitle("Message", forState: .Normal)
            
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.loadObjects()
    }
    
    @IBAction func unwindToMacthesVC(segue: UIStoryboardSegue) {
        // do nothing
    }
    
}
