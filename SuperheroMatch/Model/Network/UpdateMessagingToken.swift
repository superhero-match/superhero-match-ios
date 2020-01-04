//
//  UpdateMessagingToken.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class UpdateMessagingToken {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func updateMessagingToken(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.FIREBASE_TOKEN_PORT + "/api/v1/firebase_token/update_messaging_token",
            params: params,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
