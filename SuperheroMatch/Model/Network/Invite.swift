//
//  Invite.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Invite {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func inviteUser(userName: String!, inviteeName: String!, inviteeEmail: String!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHEROVILLE_MUNICIPALITY_PORT + "/api/v1/superheroville_municipality/invite_user?userName=\(userName!)&inviteeName=\(inviteeName!)&inviteeEmail=\(inviteeEmail!)",
            params: nil,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
