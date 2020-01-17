//
//  GetMatchResponse.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 16/01/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class GetMatchResponse {
    
    var status: Int64!
    var match: Superhero?
    
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
        let sgs = (json["match"] as? [String : Any])!
        let s = try Superhero(json: sgs)

        
        self.status = status
        self.match = s
        
    }
    
}
