//
//  CheckEmailResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 04/08/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class CheckEmailResponse {
    
    var status: Int64!
    var isRegistered: Bool!
    var isDeleted: Bool!
    var isBlocked: Bool!
    
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
        
        self.status = status
        self.isRegistered = isRegistered
        self.isDeleted = isDeleted
        self.isBlocked = isBlocked
        
    }
    
}
