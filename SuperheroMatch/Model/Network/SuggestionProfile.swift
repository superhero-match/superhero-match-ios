//
//  SuggestionProfile.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 22/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class SuggestionProfile {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getSuggestionProfile(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_PROFILE_PORT + "/api/v1/superhero_profile/profile",
            params: params!,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
