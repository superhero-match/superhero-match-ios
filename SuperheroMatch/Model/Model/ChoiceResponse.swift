//
//  ChoiceResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 01/01/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ChoiceResponse {
    
    var status: Int64!
    var isMatch: Bool!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract status
        guard let status = json["status"] as? Int64 else {
            throw SerializationError.missing("status")
        }
        
        // Extract isMatch
        guard let isMatch = json["isMatch"] as? Bool else {
            throw SerializationError.missing("isMatch")
        }
        
        self.status = status
        self.isMatch = isMatch
        
    }
    
}
