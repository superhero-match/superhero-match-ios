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

class ChatDB {
    
    static let sharedDB = ChatDB()
    
    // Updates message status to has been read.
    func updateMessageHasBeenReadByMessageId(messageId: Int64!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = "UPDATE \(DBConstants.TABLE_MESSAGE) SET \(DBConstants.MESSAGE_HAS_BEEN_READ)=1 WHERE \(DBConstants.MESSAGE_ID)=\(messageId!)"
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Fetch unread messages count for chat with id.
    func getUnreadMessageCountByChatId(chatId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var unreadMessageCount:String? = nil
        
        let query = """
        SELECT COUNT (*) AS c
        FROM \(DBConstants.TABLE_MESSAGE)
        WHERE \(DBConstants.MESSAGE_HAS_BEEN_READ)=0
        AND \(DBConstants.MESSAGE_CHAT_ID)='\(chatId!)'
        """;
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUnreadMessageCount = sqlite3_column_text(stmt, 0)
                    unreadMessageCount = String(cString:rawUnreadMessageCount!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, unreadMessageCount)
    }
    
    // Fetch last message in chat with id.
    func getLastChatMessageByChatId(chatId: String!) -> (DBError, Message?) {
        var err:DBError = .NoError
        var message:Message? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_MESSAGE)
            WHERE \(DBConstants.MESSAGE_CHAT_ID) ='\(chatId!)'
            ORDER BY \(DBConstants.MESSAGE_ID)
            DESC LIMIT 1
            """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let messageId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawMessageChatId = sqlite3_column_text(stmt, 1)
                    let messageChatId = String(cString:rawMessageChatId!)
                    
                    let rawMessageSenderId = sqlite3_column_text(stmt, 2)
                    let messageSenderId = String(cString:rawMessageSenderId!)
                    
                    let rawMessageText = sqlite3_column_text(stmt, 3)
                    let messageText = String(cString:rawMessageText!)
                    
                    let messageHasBeenRead:Int64 = sqlite3_column_int64(stmt, 4)
                    
                    let rawMessageCreated = sqlite3_column_text(stmt, 5)
                    let messageCreated = String(cString:rawMessageCreated!)
                    
                    message = Message(messageId: messageId, messageChatId: messageChatId, messageSenderId: messageSenderId, messageText: messageText, messageCreated: messageCreated)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, message)
    }
    
    // Fetch all messages for chat with id.
    func getAllMessagesForChatWithId(chatId: String!) -> (DBError, Array<Message>) {
        var err:DBError = .NoError
        var messages:Array<Message> = Array<Message>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_MESSAGE)
            WHERE \(DBConstants.MESSAGE_CHAT_ID) ='\(chatId!)'
            """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let messageId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawMessageChatId = sqlite3_column_text(stmt, 1)
                    let messageChatId = String(cString:rawMessageChatId!)
                    
                    let rawMessageSenderId = sqlite3_column_text(stmt, 2)
                    let messageSenderId = String(cString:rawMessageSenderId!)
                    
                    let rawMessageText = sqlite3_column_text(stmt, 3)
                    let messageText = String(cString:rawMessageText!)
                    
                    let messageHasBeenRead:Int64 = sqlite3_column_int64(stmt, 4)
                    
                    let rawMessageCreated = sqlite3_column_text(stmt, 5)
                    let messageCreated = String(cString:rawMessageCreated!)
                    
                    let message = Message(messageId: messageId, messageChatId: messageChatId, messageSenderId: messageSenderId, messageText: messageText, messageCreated: messageCreated)
                    
                    messages.append(message)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        return (err, messages)
    }
    
    // Fetch unread messages count for chat with id.
    func getChatIdByChatName(chatName: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var chatId:String? = nil
        
        let query = """
        SELECT \(DBConstants.CHAT_ID) FROM \(DBConstants.TABLE_CHAT)
        WHERE \(DBConstants.CHAT_NAME)='\(chatName!)'
        """;
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawChatId = sqlite3_column_text(stmt, 0)
                    chatId = String(cString:rawChatId!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, chatId)
    }
    
    // Fetch all chats.
    func getAllChats() -> (DBError, Array<Chat>) {
        var err:DBError = .NoError
        var chats:Array<Chat> = Array<Chat>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_CHAT)";
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let rawChatId = sqlite3_column_text(stmt, 0)
                    let chatId = String(cString:rawChatId!)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let rawMatchedUserId = sqlite3_column_text(stmt, 2)
                    let matchedUserId = String(cString:rawMatchedUserId!)
                    
                    let rawMatchedUserMainProfilePic = sqlite3_column_text(stmt, 3)
                    let matchedUserMainProfilePic = String(cString:rawMatchedUserMainProfilePic!)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 4)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                    let (dbErr, lastActivityMessage) = getLastChatMessageByChatId(chatId: chatId)
                    if case .SQLError = dbErr {
                        print("###########  lastActivityMessage dbErr  ##############")
                        print(dbErr)
                    }
                    
                    let (err, unreadMessageCount) = getUnreadMessageCountByChatId(chatId: chatId)
                    if case .SQLError = err {
                        print("###########  unreadMessageCount dbErr  ##############")
                        print(dbErr)
                    }
                    
                    
                    let chat = Chat(chatID: chatId, chatName: chatName, matchedUserId: matchedUserId, matchedUserMainProfilePic: matchedUserMainProfilePic, lastActivityMessage: lastActivityMessage?.messageText, lastActivityDate: lastActivityMessage?.messageCreated, unreadMessageCount: Int64(unreadMessageCount ?? ""))
                    
                    
                    chats.append(chat)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        return (err, chats)
    }
    
    // Fetch chat by chat id.
    func getChatById(chatId: String!) -> (DBError, Chat?) {
        var err:DBError = .NoError
        var chat:Chat? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_CHAT)
            WHERE \(DBConstants.CHAT_ID)='\(chatId!)'
            """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawChatId = sqlite3_column_text(stmt, 0)
                    let chatId = String(cString:rawChatId!)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let rawMatchedUserId = sqlite3_column_text(stmt, 2)
                    let matchedUserId = String(cString:rawMatchedUserId!)
                    
                    let rawMatchedUserMainProfilePic = sqlite3_column_text(stmt, 3)
                    let matchedUserMainProfilePic = String(cString:rawMatchedUserMainProfilePic!)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 4)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                    let (dbErr, lastActivityMessage) = getLastChatMessageByChatId(chatId: chatId)
                    if case .SQLError = dbErr {
                        print("###########  lastActivityMessage dbErr  ##############")
                        print(dbErr)
                    }
                    
                    let (err, unreadMessageCount) = getUnreadMessageCountByChatId(chatId: chatId)
                    if case .SQLError = err {
                        print("###########  unreadMessageCount dbErr  ##############")
                        print(dbErr)
                    }
                    
                    chat = Chat(chatID: chatId, chatName: chatName, matchedUserId: matchedUserId, matchedUserMainProfilePic: matchedUserMainProfilePic, lastActivityMessage: lastActivityMessage?.messageText, lastActivityDate: lastActivityMessage?.messageCreated, unreadMessageCount: Int64(unreadMessageCount ?? ""))
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, chat)
    }
    
    // Fetch chat by matched user id.
    func getChatByMatchedUserId(matchedUserId: String!) -> (DBError, Chat?) {
        var err:DBError = .NoError
        var chat:Chat? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_CHAT)
            WHERE \(DBConstants.CHAT_MATCHED_USER_ID)='\(matchedUserId!)'
            """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawChatId = sqlite3_column_text(stmt, 0)
                    let chatId = String(cString:rawChatId!)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let rawMatchedUserId = sqlite3_column_text(stmt, 2)
                    let matchedUserId = String(cString:rawMatchedUserId!)
                    
                    let rawMatchedUserMainProfilePic = sqlite3_column_text(stmt, 3)
                    let matchedUserMainProfilePic = String(cString:rawMatchedUserMainProfilePic!)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 4)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                    let (dbErr, lastActivityMessage) = getLastChatMessageByChatId(chatId: chatId)
                    if case .SQLError = dbErr {
                        print("###########  lastActivityMessage dbErr  ##############")
                        print(dbErr)
                    }
                    
                    let (err, unreadMessageCount) = getUnreadMessageCountByChatId(chatId: chatId)
                    if case .SQLError = err {
                        print("###########  unreadMessageCount dbErr  ##############")
                        print(dbErr)
                    }
                    
                    chat = Chat(chatID: chatId, chatName: chatName, matchedUserId: matchedUserId, matchedUserMainProfilePic: matchedUserMainProfilePic, lastActivityMessage: lastActivityMessage?.messageChatId, lastActivityDate: lastActivityMessage?.messageCreated, unreadMessageCount: Int64(unreadMessageCount ?? ""))
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, chat)
    }
    
    // Delete chat by id.
    func deleteChatById(chatId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_CHAT) WHERE \(DBConstants.CHAT_ID)='\(chatId!)'"
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Delete chat message by id.
    func deleteChatMessageById(messageId: Int64!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_MESSAGE) WHERE \(DBConstants.MESSAGE_ID) = \(messageId!)"
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Delete chat message by sender id.
    func deleteChatMessageBySenderId(senderId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_MESSAGE) WHERE \(DBConstants.MESSAGE_SENDER_ID) = '\(senderId!)'"
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Create new chat,
    func insertChat(chatId: String!, chatName: String!, matchedUserId: String!, matchedUserProfilePicUrl: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_CHAT) (\(DBConstants.CHAT_ID), \(DBConstants.CHAT_NAME), \(DBConstants.CHAT_MATCHED_USER_ID), \(DBConstants.CHAT_MATCHED_USER_MAIN_PROFILE_PIC))
            VALUES
            ('\(chatId!)', '\(chatName!)', '\(matchedUserId!)', '\(matchedUserProfilePicUrl!)')
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Create new chat message queue item
    func insertChatMessageQueueItem(messageUUID: String!, receiverId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MESSAGE_QUEUE)
            (
            \(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID),
            \(DBConstants.MESSAGE_QUEUE_MESSAGE_RECEIVER_ID)
            )
            VALUES
            ('\(messageUUID!)', '\(receiverId!)')
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    //
    // TO-DO: MessageQueueItem getMessageQueueItemChat
    
    
    // Delete chat message by uuid.
    func deleteChatMessageQueueItemByUUID(messageUUID: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            DELETE FROM \(DBConstants.TABLE_MESSAGE_QUEUE)
            WHERE \(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID)='\(messageUUID!)'
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Create new chat message.
    func insertChatMessage(messageSenderId: String!, messageChatId: String!, messageHasBeenRead: Int64!, messageCreated: String!, messagetText: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MESSAGE)
            (
            \(DBConstants.MESSAGE_SENDER_ID),
            \(DBConstants.MESSAGE_CHAT_ID),
            \(DBConstants.MESSAGE_HAS_BEEN_READ),
            \(DBConstants.MESSAGE_CREATED),
            \(DBConstants.TEXT_MESSAGE)
            )
            VALUES
            (
            '\(messageSenderId!)',
            '\(messageChatId!)',
            \(messageHasBeenRead!),
            '\(messageCreated!)',
            '\(messagetText!)'
            )
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Create new received online message.
    func insertReceivedOnlineMessage(messageUUID: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)
            (\(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID)
            VALUES
            ('\(messageUUID!)')
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Delete received online message by uuid
    func deleteReceivedOnlineMessageByUUID(uuid: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let sql = """
            DELETE FROM \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)
            WHERE \(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID)='\(uuid!)'
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    
    //  TO-DO:  public ReceivedOnlineMessage getReceivedOnlineMessage
    
    // Fetch all received online messages uuids
    func getReceivedOnlineMessageUUIDs() -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var uuids:Array<String> = Array<String>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = "SELECT \(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID) FROM \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)";
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let rawUUID = sqlite3_column_text(stmt, 0)
                    let uuid = String(cString:rawUUID!)
                    
                    uuids.append(uuid)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        return (err, uuids)
    }
    
    
}
