//
//  Choice.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Choice {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func uploadChoice(params: [String: Any], closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_CHOICE_PORT + "/api/v1/choice/choice",
            params: params,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
