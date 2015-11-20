//
//  createEventMatchbyEventChoice.swift
//  Devent
//
//  Created by Erman Sefer on 03/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

func createEventMatchbyEventChoice(event: PFObject) {

    let mainquery = PFQuery(className: "Action")
        .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("type", equalTo: "matched")
    
    mainquery.findObjectsInBackgroundWithBlock({
        object, error in
        
        for action in object! {
            
            if action.objectId != nil {
                
                var otherUserArray = [PFObject]()
                let otherUserId = action["byUser"] as! String
                let queryUser = PFQuery(className: "_User")
                    .whereKey("objectId", equalTo: otherUserId)
                
                do {
                    otherUserArray = try queryUser.findObjects()
                }
                catch {
                }
                
                let otherUserRelation = otherUserArray[0].relationForKey("userEvents")
                let otherUserQuery = otherUserRelation.query()
                var myOtherUserArray = [String]()
                
                do {
                    let abcd = try otherUserQuery.findObjects()
                    
                    for object in abcd {
                        let name = object.objectId as String?
                        myOtherUserArray.append(name!)
                    }
                }
                catch {
                }
                
                if myOtherUserArray.contains(event.objectId!) {
                    
                    let jointEvent = PFObject(className: "MatchedEvent")
                    jointEvent.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
                    jointEvent.setObject(PFUser.currentUser()!["firstName"], forKey: "byUserName")
                    jointEvent.setObject(PFUser.currentUser()!["profilePicture"], forKey: "byUserPicture")
                    jointEvent.setObject(otherUserId, forKey: "toUser")
                    jointEvent.setObject(otherUserArray[0]["firstName"], forKey: "toUserName")
                    jointEvent.setObject(otherUserArray[0]["profilePicture"], forKey: "toUserPicture")
                    jointEvent.setObject(event.objectId!, forKey: "matchedEvents")
                    jointEvent.setObject(event["Name"], forKey: "matchedEventName")
                    jointEvent.saveInBackground()
                    
                }
                
            }
        }
        
        
    })


}