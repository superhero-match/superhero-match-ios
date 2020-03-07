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

class Chat {
    
    var chatID: String!
    var chatName: String!
    var matchedUserId: String!
    var matchedUserMainProfilePic: String!
    var lastActivityMessage: String!
    var lastActivityDate: String!
    var unreadMessageCount: Int64!
    
    init(chatID: String!, chatName: String!, matchedUserId: String!, matchedUserMainProfilePic: String!, lastActivityMessage: String!, lastActivityDate: String!, unreadMessageCount: Int64!) {
        
        self.chatID = chatID
        self.chatName = chatName
        self.matchedUserId = matchedUserId
        self.matchedUserMainProfilePic = matchedUserMainProfilePic
        self.lastActivityMessage = lastActivityMessage
        self.lastActivityDate = lastActivityDate
        self.unreadMessageCount = unreadMessageCount
        
    }
    
}
