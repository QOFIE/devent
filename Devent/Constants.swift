//
//  Constants.swift
//  Devent
//
//  Created by Can Ceran on 30/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import Foundation

// For user attributes
struct USER {
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let age = "userAge"
    static let profilePicture = "profilePicture"
    static let location = "locationCity"
    static let about = "about"
    static let work = "work"
    static let education = "education"
    static let openTo = "openTo"
    static let height = "height"
    static let tags = "tags"
    static let events = "events"
    static let gender = "gender"
    static let genderInterestedIn = "genderInterestedIn"
    static let minAge = "minAge"
    static let maxAge = "maxAge"
    static let categoryChoices = "categoryChoices"
}

// For event attributes
struct EVENT {
    static let name = "name"
    static let date = "date"
    static let type = "type"
    static let price = "price"
    static let currency = "currency"
    static let address = "address"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let featured = "featured"
    static let popularity = "popularity"
    static let image = "image"
}

// For event categories
struct EventType {
    static let movie = "Movie"
    static let music = "Music"
    static let sports = "Sports"
    static let stageArts = "Stage Arts"
    static let artsAndCraft = "Arts & Craft"
    static let entertainment = "Entertainment"
    static let other = "Other"
}


// For event tableView cell identifiers
struct EventTableViewCellIdentifier {
    static let featured = "FeaturedEventsCell"
    static let sorting = "SortingCell"
    static let event = "EventCell"
}

// Universal event categories in the app. Add or delete categories here. 
let eventCategories = [
    EventType.artsAndCraft,
    EventType.entertainment,
    EventType.movie,
    EventType.music,
    EventType.sports,
    EventType.stageArts,
    EventType.other
]

// For event sorting options
struct SortBy {
    static let popularity = "popularity"
    static let date = "date"
    static let price = "price"
}

// For what kind of relationship the user is open to
struct OpenTo {
    static let relationship = "Relationship"
    static let dating = "Dating"
    static let casual = "Casual"
    static let friendship = "Friendship"
}