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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
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
        
        let query = PFQuery(className: "MatchedEvent").whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        let query2 = PFQuery(className: "MatchedEvent").whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        
        
        if searchBar.text == "" {
            
            let query3 = PFQuery.orQueryWithSubqueries([query, query2])
            query3.orderByAscending("matchedEventName")
            return query3
            
        }
            
        else {
            let query3 = PFQuery.orQueryWithSubqueries([query, query2]).whereKey("matchedEventName", containsString: searchBar.text)
            query3.orderByAscending("matchedEventName")
            return query3
            
        }
        
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
                otherUserArray = try queryUser.findObjects()}
            catch {}
            
            cell.matchedUserName.text = otherUserArray[0]["firstName"] as? String
            
            let initialThumbnail = UIImage(named: "question")
            cell.matchedEventProfilePicture.image = initialThumbnail
            if let thumbnail = otherUserArray[0]["profilePicture"] as? PFFile{
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
            let destinationVC = segue.destinationViewController as! MessageViewController
            destinationVC.groupId = eventId
            destinationVC.byUserIdForPicture = byUserId
            destinationVC.toUserIdForPicture = toUserId
            
        }
            
        else if segue.identifier == "paySeque" {
            let destinationVC = segue.destinationViewController as! PaymentPageViewController
            destinationVC.groupId = eventNameId
            destinationVC.macthedEventObjectId = eventId
            
        }
            
        else {
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.loadObjects()
    }
    
}
