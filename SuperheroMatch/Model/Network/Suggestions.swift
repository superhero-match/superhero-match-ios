//
//  Suggestions.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class Suggestions {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func suggestions(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_SUGGESTIONS_PORT + "/api/v1/suggestions/suggestions",
            params: params!,
            method: .post,
            encoding: URLEncoding.httpBody
        ) { json, error in
            closure(json, error)
        }
    }
    
}
