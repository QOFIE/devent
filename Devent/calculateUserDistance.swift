//
//  calculateUserDistance.swift
//  Devent
//
//  Created by Erman Sefer on 02/12/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

public class calculateUserDistance {
    class func isConnectedToNetwork(user: PFUser) -> Float {
        
    let latOfCurrentUser = PFUser.currentUser()?.objectForKey("latitude") as? String
    var latOfCurrentUserFloat = NSNumberFormatter().numberFromString(latOfCurrentUser!)!.floatValue
    let lonOfCurrentUser = PFUser.currentUser()?.objectForKey("longtitude") as? String
    var lonOfCurrentUserFloat = NSNumberFormatter().numberFromString(lonOfCurrentUser!)!.floatValue
        
    let latOfOtherUser = user.objectForKey("latitude") as? String
    var latOfOtherUserFloat = NSNumberFormatter().numberFromString(latOfOtherUser!)!.floatValue
    let lonOfOtherUser = user.objectForKey("longtitude") as? String
    var lonOfOtherUserFloat = NSNumberFormatter().numberFromString(lonOfOtherUser!)!.floatValue
        
    print(latOfCurrentUserFloat)
    print(lonOfCurrentUserFloat)
    print(latOfOtherUserFloat)
    print(latOfOtherUserFloat)
        
    return 3.14
}
}