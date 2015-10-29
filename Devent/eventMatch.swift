//
//  EventMatcher.swift
//  Devent
//
//  Created by Erman Sefer on 27/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

    func eventMatch() {
        /*
        
        var result = [PFObject]()
        
        let destroyQuery = PFQuery(className: "MatchedEvent")
            .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
        do {
        result = try destroyQuery.findObjects()
        }
        catch {
        }
        
        for results in result {
            do {
            try results.delete()
            }
            catch{
            }
        }
        
    */
                let mainquery = PFQuery(className: "Action")
                .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
                .whereKey("type", equalTo: "matched")
        
                 mainquery.findObjectsInBackgroundWithBlock({
                    object, error in
           
                    for action in object! {
                        
                    var matchingEvents = [String]()

                    if action.objectId != nil {
                        
                        ///// Get current user's events
                        
                        let currentUser = PFUser.currentUser()
                        let currentUserRelation = currentUser?.relationForKey("userEvents")
                        var currentUserQuery = currentUserRelation?.query()
                        var myCurrentUserArray = [String]()
                        
                        do {
                            var abc = try currentUserQuery!.findObjects()
                            
                            for object in abc {
                                var name = object.objectId as String?
                                myCurrentUserArray.append(name!)
                            }
                        }
                        catch {
                            
                        }
                        
                       
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
                        var otherUserQuery = otherUserRelation.query()
                        var myOtherUserArray = [String]()
                        
                        do {
                            var abcd = try otherUserQuery!.findObjects()
                            
                            for object in abcd {
                                var name = object.objectId as String?
                                myOtherUserArray.append(name!)
                            }
                        }
                        catch {
                            
                        }
                        
                      
                        for otherNumber in myCurrentUserArray {
                            for number in myOtherUserArray {
                                if number == otherNumber {
                                    matchingEvents.append(number)
                                    
                                    break
                                }
                            }
                        }
                        
                       
                        
                        if(matchingEvents.count > 0) {
                                
                                let sonquery = PFQuery(className: "MatchedEvent")
                                    .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!)
                                    .whereKey("toUser", equalTo: otherUserId)
                                var sonEventarray = [String]()
                                
                                do {
                                    var abc = try sonquery.findObjects()
                                    
                                    for object in abc {
                                        var name = object["matchedEvents"] as! String?
                                        sonEventarray.append(name!)
                                    }
                                }
                                catch {
                                    
                                }
                            
                            let sonquery2 = PFQuery(className: "MatchedEvent")
                                .whereKey("byUser", equalTo: otherUserId)
                                .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
                            
                            do {
                                var abc = try sonquery2.findObjects()
                                
                                for object in abc {
                                    var name = object["matchedEvents"] as! String?
                                    sonEventarray.append(name!)
                                }
                            }
                            catch {
                                
                            }
                            
                                for event in matchingEvents {
                                
                                if sonEventarray.contains(event) {
                                    print("slresdy there")
                            
                                } else {

                                    let jointEvent = PFObject(className: "MatchedEvent")
                                    jointEvent.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
                                    jointEvent.setObject(otherUserId, forKey: "toUser")
                                    jointEvent.setObject(event, forKey: "matchedEvents")
                                    jointEvent.saveInBackground()
                                
                                }
                            
                            }
                        }
                        
                    }
                    
                    
                    }
                })
    
    
    
}



