//
//  GetMatch.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 16/01/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class GetMatch {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func getMatch(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_MATCH_PORT + "/api/v1/superhero_match/get_match",
            params: params!,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
