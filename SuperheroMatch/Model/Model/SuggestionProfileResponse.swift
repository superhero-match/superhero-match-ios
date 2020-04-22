//
//  SuggestionProfileResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 22/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class SuggestionProfileResponse {
    
    var status: Int64!
    var profile: Superhero?
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json: [String: Any]) throws {
        
        // Extract status
        guard let status = json["status"] as? Int64 else {
            throw SerializationError.missing("status")
        }
        
        // Extract profile
        let prf = (json["profile"] as? [String : Any])!
        let profile = try Superhero(json: prf)

        
        self.status = status
        self.profile = profile
        
    }
    
}
