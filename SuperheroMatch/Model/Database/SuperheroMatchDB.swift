//
//  SuperheroMatchDB.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

public enum DBError {
    case NoError
    case NoSuchErrand
    case SQLError(String)
}

let RETRY_LIMIT:Int = 10

class SuperheroMatchDB: NSObject {
    
    var dbIsOpen:Bool = false
    var lastError:Error? = nil
    var dbPath:String = ""
    
    static let sharedDB = SuperheroMatchDB()
    
    private override init() {
        let fileURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("superheroMatch.db")
        self.dbPath = fileURL.path
    }
    
    //open db
    func dbOpen() -> OpaquePointer? {
        
        var db:OpaquePointer? = nil
        let result = sqlite3_open(self.dbPath as String, &db)
        
        if SQLITE_OK == result {
            print("Database has been opened")
        } else {
            print("Database could not be opened")
        }
        
        return db
        
    }
    
    //close db
    func dbClose(db:OpaquePointer) -> Int32 {
        return sqlite3_close(db)
    }
    
    func createVersionTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_VERSION, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_VERSION, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func insertVersion(dbVersion: Int64) -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "INSERT INTO version (version) VALUES(\(dbVersion))", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "INSERT INTO version (version) VALUES(\(dbVersion))", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    // Fetch database version.
    func getDBVersion() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var dbVersion:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.VERSION) FROM \(DBConstants.TABLE_VERSION)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.VERSION) FROM \(DBConstants.TABLE_VERSION)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    dbVersion = sqlite3_column_int64(stmt, 0)
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, dbVersion)
    }
    
    
    func createUserTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func insertDefaultUser() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.INSERT_DEFAULT_USER, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.INSERT_DEFAULT_USER, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createUserPictureTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER_PROFILE_PICTURE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER_PROFILE_PICTURE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createChatTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MATCH_CHAT, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MATCH_CHAT, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createMessageTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CHAT_MESSAGE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CHAT_MESSAGE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createMessageQueueTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE_QUEUE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE_QUEUE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createRetrievedOfflineMessageUUIDTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createReceivedOnlineMessageTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_MESSAGE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_MESSAGE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createDB() -> DBError {
        
        var err:DBError = .NoError
        
        err = createVersionTable()
        if case .SQLError = err {
            return err
        }
        
        err = insertVersion(dbVersion: DBConstants.DB_VERSION)
        if case .SQLError = err {
            return err
        }
        
        err = createUserTable()
        if case .SQLError = err {
           return err
        }

        err = insertDefaultUser()
        if case .SQLError = err {
            return err
        }
        
        err = createUserPictureTable()
        if case .SQLError = err {
            return err
        }
        
        err = createChatTable()
        if case .SQLError = err {
            return err
        }
        
        err = createMessageTable()
        if case .SQLError = err {
            return err
        }
        
        err = createMessageQueueTable()
        if case .SQLError = err {
            return err
        }
        
        err = createRetrievedOfflineMessageUUIDTable()
        if case .SQLError = err {
            return err
        }
        
        err = createReceivedOnlineMessageTable()
        if case .SQLError = err {
            return err
        }
        
        return err
        
    }
    
}
