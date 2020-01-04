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
    
    static let SUPERHERO_REGISTER_PORT: String = ":3000"
    static let SUPERHERO_UPDATE_PORT: String = ":3100"
    static let SUPERHERO_SCREEN_PORT: String = ":3200"
    static let SUPERHERO_DELETE_PORT: String = ":3300"
    static let SUPERHERO_UPGRADE_PORT: String = ":3400"
    static let SUPERHERO_INVITE_PORT: String = ":3600"
    static let SUPERHERO_SUGGESTIONS_PORT: String = ":4000"
    static let SUPERHERO_CHOICE_PORT: String = ":4100"
    static let SUPERHERO_MATCH_PORT: String = ":4200"
    static let SUPERHERO_DELETE_MATCH_PORT: String = ":4300"
    static let SUPERHERO_CHAT_PORT: String = ":5000"
    static let FIREBASE_TOKEN_PORT: String = ":6000"
    
    static let DEFAULT_MAX_DISTANCE: Int = 50
    static let DEFAULT_MIN_AGE: Int = 25
    static let DEFAULT_MAX_AGE: Int = 55
    static let DEFAULT_ACCOUNT_TYPE: String = "FREE"
    
    static let KILOMETERS: String = "km"
    static let MILES: String = "mi"
    
    static let MALE: Int = 1
    static let FEMALE: Int = 2
    static let BOTH: Int = 3
    
    static let MAIN_PROFILE_IMAGE_VIEW: Int = 1
    static let FIRST_PROFILE_IMAGE_VIEW: Int = 2
    static let SECOND_PROFILE_IMAGE_VIEW: Int = 3
    static let THIRD_PROFILE_IMAGE_VIEW: Int = 4
    static let FOURTH_PROFILE_IMAGE_VIEW: Int = 5
    
    static let PAGE_SIZE: Int = 10
    
}
