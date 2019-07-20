//
//  Message.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 18/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class Message {
    
    var messageId: Int64!
    var messageChatId: Int64!
    var messageSenderId: String!
    var messageReceiverId: String!
    var messageText: String!
    var messageCreated: String!
    var messageUUID: String!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(
        messageId: Int64!,
        messageChatId: Int64!,
        messageSenderId: String!,
        messageReceiverId: String!,
        messageText: String!,
        messageCreated: String!,
        messageUUID: String!
    ) {
        self.messageId = messageId
        self.messageChatId = messageChatId
        self.messageSenderId = messageSenderId
        self.messageReceiverId = messageReceiverId
        self.messageText = messageText
        self.messageCreated = messageCreated
        self.messageUUID = messageUUID
    }
    
    init(json: [String: Any]) throws {
        
        // Extract messageId
        guard let messageId = json["messageId"] as? Int64 else {
            throw SerializationError.missing("messageId")
        }
        
        // Extract messageChatId
        guard let messageChatId = json["messageChatId"] as? Int64 else {
            throw SerializationError.missing("messageChatId")
        }
        
        // Extract messageSenderId
        guard let messageSenderId = json["messageSenderId"] as? String else {
            throw SerializationError.missing("messageSenderId")
        }
        
        // Extract messageReceiverId
        guard let messageReceiverId = json["messageReceiverId"] as? String else {
            throw SerializationError.missing("messageReceiverId")
        }
        
        // Extract messageText
        guard let messageText = json["messageText"] as? String else {
            throw SerializationError.missing("messageText")
        }
        
        // Extract messageCreated
        guard let messageCreated = json["messageCreated"] as? String else {
            throw SerializationError.missing("messageCreated")
        }
        
        // Extract messageUUID
        guard let messageUUID = json["messageUUID"] as? String else {
            throw SerializationError.missing("messageUUID")
        }
        
        self.messageId = messageId
        self.messageChatId = messageChatId
        self.messageSenderId = messageSenderId
        self.messageReceiverId = messageReceiverId
        self.messageText = messageText
        self.messageCreated = messageCreated
        self.messageUUID = messageUUID
        
    }
    
}
