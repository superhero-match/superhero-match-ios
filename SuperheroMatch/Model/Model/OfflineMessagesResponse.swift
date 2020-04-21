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

class OfflineMessagesResponse {
    
     
       var status: Int64!
       var messages: [OfflineMessage] = []
       
       enum SerializationError: Error {
           case missing(String)
           case invalid(String, Any)
       }
       
       
       init(json: [String: Any]) throws {
           
           // Extract status
           guard let status = json["status"] as? Int64 else {
               throw SerializationError.missing("status")
           }
           
           // Extract messages
           guard let msgs = json["messages"] as? [[String : Any]] else {
               throw SerializationError.missing("messages")
           }
           
           for message in msgs {
               let msg = try OfflineMessage(json: message)
               self.messages.append(msg)
           }
           
           self.status = status
           
       }
    
}
