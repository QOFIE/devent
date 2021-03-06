//
//  createEventMatchbyUserMatch.swift
//  Devent
//
//  Created by Erman Sefer on 03/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

func createEventMatchbyUserMatch(user: PFUser) {

    let currentUser = PFUser.currentUser()
    let currentUserRelation = currentUser?.relationForKey("userEvent2")
    let currentUserQuery = currentUserRelation?.query()
    
    var CurrentUserArray = [String]()
    
    do {
        let abc = try currentUserQuery!.findObjects()
        
        for object in abc {
            let name = object.objectId as String?
            CurrentUserArray.append(name!)
        }
    }
    catch {
    }

    let otherUserRelation = user.relationForKey("userEvent2")
    let otherUserQuery = otherUserRelation.query()
    
    var otherUserArray = [String]()
    
    do {
        let abc = try otherUserQuery!.findObjects()
        
        for object in abc {
            let name = object.objectId as String?
            otherUserArray.append(name!)
        }
    }
    catch {
    }

    var matchingEvents = [String]()
    for otherNumber in CurrentUserArray {
        for number in otherUserArray {
            if number == otherNumber {
                matchingEvents.append(number)
                
                break
            }
        }
    }

    if(matchingEvents.count > 0) {
        
        let otherUserName = user.objectForKey("firstName")
        
        let alertController = DBAlertController(title: "Match!", message: "You have new matching events with \(otherUserName!), go check now! ", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        //let imageView = UIImageView(frame: CGRectMake(220, 10, 40, 40))
        //imageView.image = UIImage(named: "celebrate")
        //alertController.view.addSubview(imageView)
        alertController.show()
        
        
        for event in matchingEvents {
            
            
            var eventNameArray = [PFObject]()
            
            let eventNameQuery = PFQuery(className: "Events")
                .whereKey("objectId", equalTo: event)
            
            do {
                eventNameArray = try eventNameQuery.findObjects()}
            catch {}
                
                let jointEvent = PFObject(className: "MatchedEvent")
                jointEvent.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
                jointEvent.setObject(PFUser.currentUser()!["firstName"], forKey: "byUserName")
                jointEvent.setObject(PFUser.currentUser()!["profilePicture"], forKey: "byUserPicture")
                jointEvent.setObject(user.objectId!, forKey: "toUser")
                jointEvent.setObject(user["firstName"], forKey: "toUserName")
                jointEvent.setObject(user["profilePicture"], forKey: "toUserPicture")
                jointEvent.setObject(event, forKey: "matchedEvents")
                jointEvent.setObject(eventNameArray[0]["name"], forKey: "matchedEventName")
                jointEvent.setObject(eventNameArray[0]["date"], forKey: "eventDate")
                jointEvent.saveInBackground()
                
            }
        
        }
    }


