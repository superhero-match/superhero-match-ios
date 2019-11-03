//
//  UpdateProfileResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 03/11/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class UpdateProfileResponse {
    
    var status: Int64!
    var updated: Bool!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract status
        guard let status = json["status"] as? Int64 else {
            throw SerializationError.missing("status")
        }
        
        // Extract updated
        guard let updated = json["updated"] as? Bool else {
            throw SerializationError.missing("updated")
        }
        
        self.status = status
        self.updated = updated
        
    }
    
}
