//
//  SuggestionsResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 22/09/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class SuggestionsResponse {
    
    var status: Int64!
    var suggestions: [Superhero]?
    
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
        guard let sgs = json["suggestions"] as? [[String : Any]] else {
            throw SerializationError.missing("suggestions")
        }
        
        for suggestion in sgs {
            let s = try Superhero(json: suggestion)
            self.suggestions?.append(s)
        }
        
        self.status = status
        
    }
    
}
