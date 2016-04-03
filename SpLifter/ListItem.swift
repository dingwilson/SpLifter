//
//  ListItem.swift
//  
//
//  Created by Wilson Ding on 4/3/16.
//
//

import Foundation

class ListItem {
    var currentFullName_ : String
    var currentImageUrl_ : String
    var currentUserId_ : String
    var destinationLocationClosestLat_ : String
    var destinationLocationClosestLong_ : String
    var destinationLocationClosestName_ : String
    var matchedFullName_ : String
    var matchedImageUrl_ : String
    var matchedUserId_ : String
    var uberDistance_ : String
    var uberPrice_ : String
    var userLocationClosestLat_ : String
    var userLocationClosestLong_ : String
    var userLocationClosestName_ : String
    
    init(currentFullName: String, currentImageUrl: String, currentUserId: String, destinationLocationClosestLat: String, destinationLocationClosestLong: String, destinationLocationClosestName: String, matchedFullName: String, matchedImageUrl: String, matchedUserId: String, uberDistance: String, uberPrice: String, userLocationClosestLat: String, userLocationClosestLong: String, userLocationClosestName: String) {
        
        self.currentFullName_ = currentFullName
        self.currentImageUrl_ = currentImageUrl
        self.currentUserId_ = currentUserId
        self.destinationLocationClosestLat_ = destinationLocationClosestLat
        self.destinationLocationClosestLong_ = destinationLocationClosestLong
        self.destinationLocationClosestName_ = destinationLocationClosestName
        self.matchedFullName_ = matchedFullName
        self.matchedImageUrl_ = matchedImageUrl
        self.matchedUserId_ = matchedUserId
        self.uberDistance_ = uberDistance
        self.uberPrice_ = uberPrice
        self.userLocationClosestLat_ = userLocationClosestLat
        self.userLocationClosestLong_ = userLocationClosestLong
        self.userLocationClosestName_ = userLocationClosestName
    }
    
    
    func currentFullName() -> String! {
        return currentFullName_
    }
    
    func currentImageUrl() -> String! {
        return currentImageUrl_
    }
    
    func currentUserId() -> String! {
        return currentUserId_
    }
    
    func destinationLocationClosestLat() -> String! {
        return destinationLocationClosestLat_
    }
    
    func destinationLocationClosestLong() -> String! {
        return destinationLocationClosestLong_
    }
    
    func destinationLocationClosestName() -> String! {
        return destinationLocationClosestName_
    }
    
    func matchedFullName() -> String! {
        return matchedFullName_
    }
    
    func matchedImageUrl() -> String! {
        return matchedImageUrl_
    }
    
    func matchedUserId() -> String! {
        return matchedUserId_
    }
    
    func uberDistance() -> String! {
        return uberDistance_
    }

    func uberPrice() -> String! {
        return uberPrice_
    }
    
    func userLocationClosestLat() -> String! {
        return userLocationClosestLat_
    }
    
    func userLocationClosestLong() -> String! {
        return userLocationClosestLong_
    }
    
    func userLocationClosestName() -> String! {
        return userLocationClosestName_
    }
}