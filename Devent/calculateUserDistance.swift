//
//  calculateUserDistance.swift
//  Devent
//
//  Created by Erman Sefer on 02/12/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

public class calculateUserDistance {
    class func realDistance(user: PFObject) -> Double {
        
        var latOfCurrentUserFloat: CLLocationDegrees = 0.0
        var lonOfCurrentUserFloat: CLLocationDegrees = 0.0
        var latOfOtherUserFloat: CLLocationDegrees = 0.0
        var lonOfOtherUserFloat: CLLocationDegrees = 0.0
        
        let latOfCurrentUser = PFUser.currentUser()?.objectForKey("latitude") as? String
        if (latOfCurrentUser != nil) {
            latOfCurrentUserFloat = NSNumberFormatter().numberFromString(latOfCurrentUser!)!.doubleValue
            
        }
        
        let lonOfCurrentUser = PFUser.currentUser()?.objectForKey("longtitude") as? String
        if (lonOfCurrentUser != nil) {
            lonOfCurrentUserFloat = NSNumberFormatter().numberFromString(lonOfCurrentUser!)!.doubleValue
            
        }
        
        let latOfOtherUser = user.objectForKey("latitude") as? String
        if (latOfOtherUser != nil) {
            latOfOtherUserFloat = NSNumberFormatter().numberFromString(latOfOtherUser!)!.doubleValue
            
        }
        
        let lonOfOtherUser = user.objectForKey("longtitude") as? String
        if (lonOfOtherUser != nil) {
            lonOfOtherUserFloat = NSNumberFormatter().numberFromString(lonOfOtherUser!)!.doubleValue
            
        }
        
        let currentUserlocation: CLLocation = CLLocation(latitude: latOfCurrentUserFloat, longitude: lonOfCurrentUserFloat)
        let OtherUserlocation: CLLocation = CLLocation(latitude: latOfOtherUserFloat, longitude: lonOfOtherUserFloat)
        
        var distance = currentUserlocation.distanceFromLocation(OtherUserlocation)
        print(distance)
        print(distance/1000.0)
        return distance/1000.0
    }
}