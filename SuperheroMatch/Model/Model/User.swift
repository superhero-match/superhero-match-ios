//
//  User.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class User {
    
    var userID: String!
    var email: String?
    var name: String!
    var superheroName: String!
    var mainProfilePicUrl: String!
    var profilePicsUrls: [String]?
    var gender: Int64!
    var lookingForGender: Int64?
    var age: Int64!
    var lookingForAgeMin: Int64?
    var lookingForAgeMax: Int64?
    var lookingForDistanceMax: Int64?
    var distanceUnit: String?
    var lat: Double?
    var lon: Double?
    var birthday: String?
    var country: String?
    var city: String?
    var superPower: String!
    var accountType: String!
    
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(
        userID: String!,
        email: String?,
        name: String!,
        superheroName: String!,
        mainProfilePicUrl: String!,
        profilePicsUrls: [String]!,
        gender: Int64!,
        lookingForGender: Int64?,
        age: Int64!,
        lookingForAgeMin: Int64?,
        lookingForAgeMax: Int64?,
        lookingForDistanceMax: Int64?,
        distanceUnit: String?,
        lat: Double?,
        lon: Double?,
        birthday: String?,
        country: String?,
        city: String?,
        superPower: String!,
        accountType: String!
    ) {
            self.userID = userID
            self.email = email
            self.name = name
            self.superheroName = superheroName
            self.mainProfilePicUrl = mainProfilePicUrl
            self.profilePicsUrls = profilePicsUrls
            self.gender = gender
            self.lookingForGender = lookingForGender
            self.age = age
            self.lookingForAgeMin = lookingForAgeMin
            self.lookingForAgeMax = lookingForAgeMax
            self.lookingForDistanceMax = lookingForDistanceMax
            self.distanceUnit = distanceUnit
            self.lat = lat
            self.lon = lon
            self.birthday = birthday
            self.country = country
            self.city = city
            self.superPower = superPower
            self.accountType = accountType
    }
    
    
    init(json: [String: Any]) throws {

        // Extract userID
        guard let userID = json["userID"] as? String else {
            throw SerializationError.missing("userID")
        }

        // Extract email
        let email = ((json["email"] as? String) != nil) ? json["email"] as? String : ""

        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract superheroName
        guard let superheroName = json["superheroName"] as? String else {
            throw SerializationError.missing("superheroName")
        }

        // Extract mainProfilePicUrl
        guard let mainProfilePicUrl = json["mainProfilePicUrl"] as? String else {
            throw SerializationError.missing("mainProfilePicUrl")
        }

        // Extract profilePicsUrls
        guard let profilePicsUrls = json["profilePicsUrls"] as? [String] else {
            throw SerializationError.missing("profilePicsUrls")
        }
        
        // Extract gender
        guard let gender = json["gender"] as? Int64 else {
            throw SerializationError.missing("gender")
        }
        
        // Extract lookingForGender
        let lookingForGender = ((json["lookingForGender"] as? Int64) != nil) ? json["lookingForGender"] as? Int64 : 0
        
        // Extract age
        guard let age = json["age"] as? Int64 else {
            throw SerializationError.missing("age")
        }
        
        // Extract lookingForAgeMin
        let lookingForAgeMin = ((json["lookingForAgeMin"] as? Int64) != nil) ? json["lookingForAgeMin"] as? Int64 : 0
        
        // Extract lookingForAgeMax
        let lookingForAgeMax = ((json["lookingForAgeMax"] as? Int64) != nil) ? json["lookingForAgeMax"] as? Int64 : 0
        
        // Extract lookingForDistanceMax
        let lookingForDistanceMax = ((json["lookingForDistanceMax"] as? Int64) != nil) ? json["lookingForDistanceMax"] as? Int64 : 0
        
        // Extract distanceUnit
        let distanceUnit = ((json["distanceUnit"] as? String) != nil) ? json["distanceUnit"] as? String : ""
        
        // Extract lat
        let lat = ((json["lat"] as? Double) != nil) ? json["lat"] as? Double : 0.0
        
        // Extract lon
        let lon = ((json["lon"] as? Double) != nil) ? json["lon"] as? Double : 0.0
        
        // Extract birthday
        let birthday = ((json["birthday"] as? String) != nil) ? json["birthday"] as? String : ""
        
        // Extract country
        let country = ((json["country"] as? String) != nil) ? json["country"] as? String : ""
        
        // Extract city
        let city = ((json["city"] as? String) != nil) ? json["city"] as? String : ""
        
        // Extract superPower
        guard let superPower = json["superPower"] as? String else {
            throw SerializationError.missing("superPower")
        }
        
        // Extract accountType
        guard let accountType = json["accountType"] as? String else {
            throw SerializationError.missing("accountType")
        }

        // Initialize properties
        self.userID = userID
        self.email = email
        self.name = name
        self.superheroName = superheroName
        self.mainProfilePicUrl = mainProfilePicUrl
        self.profilePicsUrls = profilePicsUrls
        self.gender = gender
        self.lookingForGender = lookingForGender
        self.age = age
        self.lookingForAgeMin = lookingForAgeMin
        self.lookingForAgeMax = lookingForAgeMax
        self.lookingForDistanceMax = lookingForDistanceMax
        self.distanceUnit = distanceUnit
        self.lat = lat
        self.lon = lon
        self.birthday = birthday
        self.country = country
        self.city = city
        self.superPower = superPower
        self.accountType = accountType

    }
    
}
