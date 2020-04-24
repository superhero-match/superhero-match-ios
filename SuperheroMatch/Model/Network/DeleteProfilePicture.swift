//
//  DeleteProfilePicture.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 24/04/2020.
//  Copyright © 2020 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import Alamofire

class DeleteProfilePicture {
    
    var networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager()
    }
    
    func deleteProfilePicture(params: [String: Any]!, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        self.networkManager.loadUrl(
            url: ConstantRegistry.BASE_SERVER_URL + ConstantRegistry.SUPERHERO_DELETE_MEDIA_PORT + "/api/v1/superhero_delete_media/delete",
            params: params!,
            method: .post,
            encoding: nil
        ) { json, error in
            closure(json, error)
        }
    }
    
}
