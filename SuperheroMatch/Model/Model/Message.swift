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
    
    var messageId: Int64?
    var messageChatId: String!
    var messageSenderId: String!
    var messageText: String!
    var messageCreated: String!
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(
        messageId: Int64?,
        messageChatId: String!,
        messageSenderId: String!,
        messageText: String!,
        messageCreated: String!
    ) {
        self.messageId = messageId
        self.messageChatId = messageChatId
        self.messageSenderId = messageSenderId
        self.messageText = messageText
        self.messageCreated = messageCreated
    }
    
    init(json: [String: Any]) throws {
        
        // Extract messageId
        let messageId = ((json["messageId"] as? Int64) != nil) ? json["messageId"] as? Int64 : 0
        
        // Extract messageChatId
        guard let messageChatId = json["messageChatId"] as? String else {
            throw SerializationError.missing("messageChatId")
        }
        
        // Extract messageSenderId
        guard let messageSenderId = json["messageSenderId"] as? String else {
            throw SerializationError.missing("messageSenderId")
        }
        
        // Extract messageText
        guard let messageText = json["messageText"] as? String else {
            throw SerializationError.missing("messageText")
        }
        
        // Extract messageCreated
        guard let messageCreated = json["messageCreated"] as? String else {
            throw SerializationError.missing("messageCreated")
        }
        
        self.messageId = messageId
        self.messageChatId = messageChatId
        self.messageSenderId = messageSenderId
        self.messageText = messageText
        self.messageCreated = messageCreated
        
    }
    
}
