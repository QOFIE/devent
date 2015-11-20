//
//  Event.swift
//  Devent
//
//  Created by Can Ceran on 14/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    // MARK: PROPERTIES
    
    var name: String
    var location: Location
    var date: NSDate
    var picture: UIImage?
    var pictureURL: String?
    var price: Double
    var currency: String
    var numberOfUsersJoining: Int
    var eventID: String
    
    // MARK: ACTIONS
    
    init(eventID: String, name: String, location: Location, date: NSDate, price: Double, currency: String) {
        self.eventID = eventID
        self.name = name
        self.location = location
        self.date = date
        self.price = price
        self.currency = currency
        self.numberOfUsersJoining = 0 // There is no one joining the event at the time of creation
    }
    
    private func fetchPictureFromURL(url: String) {
        // do nothing 
        // in case the image needs to be fetched from a URL, complete this function
    }
    
    
    
}

class Location {
    
    // MARK: PROPERTIES
    
    var longitude: Double
    var latitude: Double
    var address: String
    var phoneNumber: String?
    
    // MARK: ACTIONS
    
    init(longitude: Double, latitude: Double, address: String){
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
    
    func distanceToLocation(lon: Double, lat: Double) -> (Double, String) {
        // learn core location to code this part accurately
        return (0.0, "km")
    }

}
