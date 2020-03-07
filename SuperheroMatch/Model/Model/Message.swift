/*
  Copyright (C) 2019 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class Message {
    
    var messageId: Int64!
    var messageChatId: String!
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
        messageChatId: String!,
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
        guard let messageChatId = json["messageChatId"] as? String else {
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
