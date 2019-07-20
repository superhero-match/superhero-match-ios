//
//  ReceivedOnlineMessage.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ReceivedOnlineMessage {
    
    var _id: Int!
    var uuid: String!
    var chatName: String!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(_id: Int!, uuid: String!, chatName: String!) {
        
        self._id = _id
        self.uuid = uuid
        self.chatName = chatName
        
    }
    
    init(json: [String: Any]) throws {
        
        // Extract _id
        guard let _id = json["_id"] as? Int else {
            throw SerializationError.missing("messageId")
        }
        
        // Extract uuid
        guard let uuid = json["uuid"] as? String else {
            throw SerializationError.missing("uuid")
        }
        
        // Extract chatName
        guard let chatName = json["chatName"] as? String else {
            throw SerializationError.missing("chatName")
        }
        
        self._id = _id
        self.uuid = uuid
        self.chatName = chatName
    
    }
    
}
