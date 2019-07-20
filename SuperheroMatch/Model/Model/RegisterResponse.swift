//
//  RegisterResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 07/08/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class RegisterResponse {
    
    var status: Int64!
    var registered: Bool!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract status
        guard let status = json["status"] as? Int64 else {
            throw SerializationError.missing("status")
        }
        
        // Extract registered
        guard let registered = json["registered"] as? Bool else {
            throw SerializationError.missing("registered")
        }
        
        self.status = status
        self.registered = registered
        
    }
    
}
