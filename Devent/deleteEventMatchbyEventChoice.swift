//
//  deleteEventMatchbyEventChoice.swift
//  Devent
//
//  Created by Erman Sefer on 03/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

func deleteEventMatchbyEventChoice(event: PFObject) {

 let deleteQuery = PFQuery(className: "MatchedEvent")
    .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
    .whereKey("matchedEvents", equalTo: event.objectId!)

    deleteQuery.findObjectsInBackgroundWithBlock({
        object, error in
        
        for action in object! {
            
            action.deleteInBackground()
            
        }
    })
    
let deleteQuery2 = PFQuery(className: "MatchedEvent")
        .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("matchedEvents", equalTo: event.objectId!)
    
    deleteQuery2.findObjectsInBackgroundWithBlock({
        object, error in
        
        for action in object! {
            
            action.deleteInBackground()
            
        }
    })
    
    
    
    
    

}