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
    
    func updateMessagingToken(userID: String!, messagingToken: String!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHEROVILLE_MUNICIPALITY_PORT + "/api/v1/superheroville_municipality/update_user_messaging_token?userID=\(userID!)&messagingToken=\(messagingToken!)",
            params: nil,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
