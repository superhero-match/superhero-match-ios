/*
  Copyright (C) 2019 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class Superhero {
    
    var userID: String!
    var superheroName: String!
    var mainProfilePicUrl: String!
    var profilePictures: [ProfilePicture] = []
    var gender: Int64!
    var age: Int64!
    var birthday: String?
    var country: String?
    var city: String?
    var superpower: String!
    var accountType: String!
    var hasLikedMe: Bool!
    var createdAt: String!
    
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(
        userID: String!,
        superheroName: String!,
        mainProfilePicUrl: String!,
        profilePictures: [ProfilePicture]!,
        gender: Int64!,
        age: Int64!,
        lat: Double?,
        lon: Double?,
        birthday: String?,
        country: String?,
        city: String?,
        superpower: String!,
        accountType: String!,
        hasLikedMe: Bool!,
        createdAt: String!
    ) {
        self.userID = userID
        self.superheroName = superheroName
        self.mainProfilePicUrl = mainProfilePicUrl
        self.profilePictures = profilePictures
        self.gender = gender
        self.age = age
        self.birthday = birthday
        self.country = country
        self.city = city
        self.superpower = superpower
        self.accountType = accountType
        self.hasLikedMe = hasLikedMe
        self.createdAt = createdAt
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract userID
        guard let userID = json["id"] as? String else {
            throw SerializationError.missing("id")
        }
        
        // Extract superheroName
        guard let superheroName = json["superheroName"] as? String else {
            throw SerializationError.missing("superheroName")
        }
        
        // Extract mainProfilePicUrl
        guard let mainProfilePicUrl = json["mainProfilePicUrl"] as? String else {
            throw SerializationError.missing("mainProfilePicUrl")
        }
        
        // Extract profilePictures
        let profilePictures = ((json["profilePictures"] as? [[String : Any]]) != nil) ? json["profilePictures"] as? [[String : Any]]  : []
        
        for profilePicture in profilePictures! {
            let result = try ProfilePicture(json: profilePicture)
            self.profilePictures.append(result)
        }
        
        // Extract gender
        guard let gender = json["gender"] as? Int64 else {
            throw SerializationError.missing("gender")
        }
        
        // Extract age
        guard let age = json["age"] as? Int64 else {
            throw SerializationError.missing("age")
        }
        
        // Extract birthday
        let birthday = ((json["birthday"] as? String) != nil) ? json["birthday"] as? String : ""
        
        // Extract country
        let country = ((json["country"] as? String) != nil) ? json["country"] as? String : ""
        
        // Extract city
        let city = ((json["city"] as? String) != nil) ? json["city"] as? String : ""
        
        // Extract superPower
        guard let superpower = json["superpower"] as? String else {
            throw SerializationError.missing("superpower")
        }
        
        // Extract accountType
        guard let accountType = json["accountType"] as? String else {
            throw SerializationError.missing("accountType")
        }
        
        // Extract hasLikedMe
        let hasLikedMe = ((json["hasLikedMe"] as? Bool) != nil) ? json["hasLikedMe"] as? Bool : false
        
        // Extract createdAt
        guard let createdAt = json["createdAt"] as? String else {
            throw SerializationError.missing("createdAt")
        }
        
        // Initialize properties
        self.userID = userID
        self.superheroName = superheroName
        self.mainProfilePicUrl = mainProfilePicUrl
        self.gender = gender
        self.age = age
        self.birthday = birthday
        self.country = country
        self.city = city
        self.superpower = superpower
        self.accountType = accountType
        self.hasLikedMe = hasLikedMe
        self.createdAt = createdAt
        
    }
    
}
