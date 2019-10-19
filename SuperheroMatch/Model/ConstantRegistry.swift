//
//  ConstantRegistry.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ConstantRegistry {
    
    static let BASE_SERVER_URL: String = "https://192.168.178.13"
    static let IMAGE_URL_PREFIX: String = "https:"
    
    static let SUPERHEROVILLE_MUNICIPALITY_PORT: String = ":3000"
    static let SUPERHERO_SUGGESTIONS_PORT: String = ":4000"
    static let SUPERHERO_MATCHMAKER_PORT: String = ":5000"
    static let SUPERHERO_CHAT_PORT: String = ":6000"
    
    static let DEFAULT_MAX_DISTANCE: Int = 50
    static let DEFAULT_MIN_AGE: Int = 25
    static let DEFAULT_MAX_AGE: Int = 55
    static let DEFAULT_ACCOUNT_TYPE: String = "FREE"
    
    static let KILOMETERS: String = "km"
    static let MILES: String = "mi"
    
    static let MALE: Int = 1
    static let FEMALE: Int = 2
    static let BOTH: Int = 3
    
}
