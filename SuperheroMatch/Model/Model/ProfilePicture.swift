//
//  ProfilePicture.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 25/12/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ProfilePicture {
    
    var id: Int64!
    var superheroId: String!
    var profilePicUrl: String!
    var position: Int!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(
        id: Int64!,
        superheroId: String!,
        profilePicUrl: String!,
        position: Int!
    ) {
            self.id = id
            self.superheroId = superheroId
            self.profilePicUrl = profilePicUrl
            self.position = position
    }
    
    init(json: [String: Any]) throws {

        // Extract id
        guard let id = json["id"] as? Int64 else {
            throw SerializationError.missing("id")
        }
        
        // Extract superheroId
        guard let superheroId = json["superheroId"] as? String else {
            throw SerializationError.missing("superheroId")
        }
        
        // Extract profilePicUrl
        guard let profilePicUrl = json["profilePicUrl"] as? String else {
            throw SerializationError.missing("profilePicUrl")
        }

        // Extract position
        guard let position = json["position"] as? Int else {
            throw SerializationError.missing("position")
        }
        

        // Initialize properties
        self.id = id
        self.superheroId = superheroId
        self.profilePicUrl = profilePicUrl
        self.position = position


    }
    
}
