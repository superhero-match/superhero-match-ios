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
