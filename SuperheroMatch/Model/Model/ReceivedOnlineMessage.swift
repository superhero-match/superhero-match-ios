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
