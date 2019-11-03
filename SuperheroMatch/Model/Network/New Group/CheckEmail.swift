//
//  CheckEmail.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class CheckEmail {

    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func checkEmail(email: String!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_SCREEN_PORT + "/api/v1/superhero_screen/check_email?email=\(email!)",
            params: nil,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
