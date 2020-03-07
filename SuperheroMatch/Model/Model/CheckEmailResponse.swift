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

class CheckEmailResponse {
    
    var status: Int64!
    var isRegistered: Bool!
    var isDeleted: Bool!
    var isBlocked: Bool!
    var superhero: User?
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract status
        guard let status = json["status"] as? Int64 else {
            throw SerializationError.missing("status")
        }
        
        // Extract isRegistered
        guard let isRegistered = json["isRegistered"] as? Bool else {
            throw SerializationError.missing("isRegistered")
        }
        
        // Extract isDeleted
        guard let isDeleted = json["isDeleted"] as? Bool else {
            throw SerializationError.missing("isDeleted")
        }
        
        // Extract isBlocked
        guard let isBlocked = json["isBlocked"] as? Bool else {
            throw SerializationError.missing("isBlocked")
        }
        
        // Extract superhero
        guard let superhero = json["superhero"] as? [String : Any] else {
            throw SerializationError.missing("superhero")
        }
        
        let user = try User(json: superhero)
        
        
        self.status = status
        self.isRegistered = isRegistered
        self.isDeleted = isDeleted
        self.isBlocked = isBlocked
        self.superhero = user
        
    }
    
}
