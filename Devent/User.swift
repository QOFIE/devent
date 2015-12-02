//
//  User.swift
//  Devent
//
//  Created by Erman Sefer on 25/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    var pfUser: PFUser
    
    func getPhoto(callback: (UIImage) -> ()) {
        if let imageFile = pfUser.objectForKey("profilePicture") as? PFFile {
        
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
        }
        else {
            callback(UIImage(named: "dummy")!)
        }
    }
}

func pfUserToUser(user: PFUser) -> User {
    let name = user.objectForKey("firstName") as? String
    let userName: String = ""
    if (name != nil) {
        let userName = name
    }
    
    return User(id: user.objectId!, name: userName, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnviewedUsers(callback: ([User] -> ())) {
    
    var userArray = [PFUser]()
    
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: PFUser.currentUser()!.objectId!).findObjectsInBackgroundWithBlock({
            objects, error in
            let viewedUsers = (objects!).map({$0.objectForKey("toUser")!})
            
            PFUser.query()!
                .whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
                .whereKey("objectId", notContainedIn: viewedUsers)
                .findObjectsInBackgroundWithBlock({
                    objects, error in
                    
                    userArray.removeAll()
                    for i in objects! {
                        
                        let k = i as! PFUser
                        print("ahaha")
                        print(calculateUserDistance.realDistance(i))
                        if(calculateUserDistance.realDistance(i) < 50.0) {
                            userArray.append(k)
                        }
                        
                    }
                    
                    // if let pfUsers = objects as? [PFUser] {
                    let users = userArray.map({pfUserToUser($0)})
                    callback(users)
                    //}
                })
        })
}

func saveSkip(user: User) {
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    skip.saveInBackgroundWithBlock(nil)
}

func saveLike(user: User) {
    PFQuery(className: "Action")
        .whereKey("byUser", equalTo: user.id)
        .whereKey("toUser", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("type", equalTo: "liked")
        .getFirstObjectInBackgroundWithBlock({
            object, error in
            
            var matched = false
            
            if object != nil {
                
                
                matched = true
                object!.setObject("matched", forKey: "type")
                object!.saveInBackgroundWithBlock(nil)
                
            }
            
            
            
            let match = PFObject(className: "Action")
            match.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
            match.setObject(user.id, forKey: "toUser")
            match.setObject(matched ? "matched" : "liked", forKey: "type")
            match.saveInBackgroundWithBlock(nil)
            
            if matched {
                
                createEventMatchbyUserMatch(user.pfUser)
                
            }
            
        })
    
    
    
}



