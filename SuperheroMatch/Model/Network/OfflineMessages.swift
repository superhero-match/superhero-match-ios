//
//  OfflineMessages.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 21/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class OfflineMessages {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func offlineMessages(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_OFFLINE_MESSAGES_PORT + "/api/v1/chat/get_offline_messages",
            params: params!,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
