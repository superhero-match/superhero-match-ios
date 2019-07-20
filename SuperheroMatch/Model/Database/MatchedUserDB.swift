//
//  MatchedUserDB.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class MatchedUserDB {
    
    // Fetch chat by chat id.
    func getMatchedUserById(matchedUserId: String!) -> (DBError, User?) {
        var err:DBError = .NoError
        var matchedUser: User? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_MATCHED_USER)
            WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'
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
                    
                    let rawUserId = sqlite3_column_text(stmt, 0)
                    let userId = String(cString:rawUserId!)
                    
                    let rawUserName = sqlite3_column_text(stmt, 1)
                    let userName = String(cString:rawUserName!)
                    
                    let rawMainProfilePic = sqlite3_column_text(stmt, 2)
                    let mainProfilePic = String(cString:rawMainProfilePic!)
                    
                    let userGender = sqlite3_column_int64(stmt, 3)
                    
                    let userAge = sqlite3_column_int64(stmt, 4)
                    
                    let rawUserCountry = sqlite3_column_text(stmt, 5)
                    let userCountry = String(cString:rawUserCountry!)
                    
                    let rawUserCity = sqlite3_column_text(stmt, 6)
                    let userCity = String(cString:rawUserCity!)
                    
                    let rawUserSuperPower = sqlite3_column_text(stmt, 7)
                    let userSuperPower = String(cString:rawUserSuperPower!)
                    
                    let rawUserAccountType = sqlite3_column_text(stmt, 8)
                    let userAccountType = String(cString:rawUserAccountType!)
                    
                    let rawMatchedWithUserId = sqlite3_column_text(stmt, 9)
                    _ = String(cString:rawMatchedWithUserId!)
                    
                    let rawMatchCreated = sqlite3_column_text(stmt, 10)
                    _ = String(cString:rawMatchCreated!)
                    
                    matchedUser = User(userID: userId, email: nil, name: userName, superheroName: "Superhero 1", mainProfilePicUrl: mainProfilePic, profilePicsUrls: nil, gender: userGender, lookingForGender: nil, age: userAge, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: userCountry, city: userCity, superPower: userSuperPower, accountType: userAccountType)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, matchedUser)
    }
    
    // Fetch all matched users.
    func getAllMatchedUsers(matchedWithUserId: String!) -> (DBError, Array<User>) {
        var err:DBError = .NoError
        var matchedUsers:Array<User> = Array<User>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_MATCHED_USER)
            WHERE \(DBConstants.MATCHED_WITH_USER_ID)='\(matchedWithUserId!)'
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
                    
                    let rawUserId = sqlite3_column_text(stmt, 0)
                    let userId = String(cString:rawUserId!)
                    
                    let rawUserName = sqlite3_column_text(stmt, 1)
                    let userName = String(cString:rawUserName!)
                    
                    let rawMainProfilePic = sqlite3_column_text(stmt, 2)
                    let mainProfilePic = String(cString:rawMainProfilePic!)
                    
                    let userGender = sqlite3_column_int64(stmt, 3)
                    
                    let userAge = sqlite3_column_int64(stmt, 4)
                    
                    let rawUserCountry = sqlite3_column_text(stmt, 5)
                    let userCountry = String(cString:rawUserCountry!)
                    
                    let rawUserCity = sqlite3_column_text(stmt, 6)
                    let userCity = String(cString:rawUserCity!)
                    
                    let rawUserSuperPower = sqlite3_column_text(stmt, 7)
                    let userSuperPower = String(cString:rawUserSuperPower!)
                    
                    let rawUserAccountType = sqlite3_column_text(stmt, 8)
                    let userAccountType = String(cString:rawUserAccountType!)
                    
                    let rawMatchedWithUserId = sqlite3_column_text(stmt, 9)
                    _ = String(cString:rawMatchedWithUserId!)
                    
                    let rawMatchCreated = sqlite3_column_text(stmt, 10)
                    _ = String(cString:rawMatchCreated!)
                    
                    let matchedUser = User(userID: userId, email: nil, name: userName, superheroName: "Superhero 1", mainProfilePicUrl: mainProfilePic, profilePicsUrls: nil, gender: userGender, lookingForGender: nil, age: userAge, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: userCountry, city: userCity, superPower: userSuperPower, accountType: userAccountType)
                    
                    matchedUsers.append(matchedUser)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        return (err, matchedUsers)
    }

    // Fetch matched user's name by id.
    func getMatchedUserNameByID(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var userName:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCH_NAME) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCH_NAME) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserName = sqlite3_column_text(stmt, 0)
                    userName = String(cString:rawUserName!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, userName)
    }
    
    // Fetch user's main profile picture url.
    func getMatchedUserMainProfilePicUrlByID(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var userMainProfilePicUrl:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_MAIN_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE  \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_MAIN_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE  \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserMainProfilePicUrl = sqlite3_column_text(stmt, 0)
                    userMainProfilePicUrl = String(cString:rawUserMainProfilePicUrl!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, userMainProfilePicUrl)
    }
    
    // Fetch all matched user's profile pics by id.
    func getMatchedUserProfilePicUrls(matchedUserId: String!) -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var urls:Array<String> = Array<String>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = "SELECT \(DBConstants.MATCH_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_MATCH_PROFILE_PICTURE) WHERE \(DBConstants.PICTURE_MATCH_ID)='\(matchedUserId!)'";
            
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
                    
                    let rawUrl = sqlite3_column_text(stmt, 0)
                    let url = String(cString:rawUrl!)
                    
                    urls.append(url)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        return (err, urls)
    }
    
    // Fetch matched user's gender by id.
    func getMatchedUserGenderById(matchedUserId: String!) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var gender:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_GENDER) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_GENDER) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    gender = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, gender)
    }
    
    // Fetch matched user's age by id.
    func getMatchedUserAgeById(matchedUserId: String!) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var age:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_AGE) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_AGE) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    age = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, age)
    }
    
    // Fetch matched user's country by id.
    func getMatchedUserCountryById(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var country:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_COUNTRY) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_COUNTRY) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawCountry = sqlite3_column_text(stmt, 0)
                    country = String(cString:rawCountry!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, country)
    }
    
    // Fetch matched user's city by id.
    func getMatchedUserCityById(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var city:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_CITY) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_CITY) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawCity = sqlite3_column_text(stmt, 0)
                    city = String(cString:rawCity!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, city)
    }
    
    // Fetch matched user's super power by id.
    func getMatchedUserSuperPowerById(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var superPower:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_SUPER_POWER) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_SUPER_POWER) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawSuperPower = sqlite3_column_text(stmt, 0)
                    superPower = String(cString:rawSuperPower!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, superPower)
    }
    
    // Fetch matched user's account type by id.
    func getMatchedUserAccountTypeById(matchedUserId: String!) -> (DBError, String?) {
        var err:DBError = .NoError
        var accountType:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_ACCOUNT_TYPE) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.MATCHED_USER_ACCOUNT_TYPE) FROM \(DBConstants.TABLE_MATCHED_USER) WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawAccountType = sqlite3_column_text(stmt, 0)
                    accountType = String(cString:rawAccountType!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, accountType)
    }
    
    // Saves new matched user.
    func insertMatchedUser(user: User!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MATCHED_USER)
            (
                \(DBConstants.MATCHED_USER_ID),
                \(DBConstants.MATCHED_USER_NAME),
                \(DBConstants.MATCHED_USER_MAIN_PROFILE_PIC_URL),
                \(DBConstants.MATCHED_USER_GENDER),
                \(DBConstants.MATCHED_USER_AGE),
                \(DBConstants.MATCHED_USER_COUNTRY),
                \(DBConstants.MATCHED_USER_CITY),
                \(DBConstants.MATCHED_USER_SUPER_POWER),
                \(DBConstants.MATCHED_USER_ACCOUNT_TYPE),
                \(DBConstants.MATCHED_WITH_USER_ID)
            )
            VALUES
            (
                '\(user.userID!)',
                '\(user.name!)',
                '\(user.mainProfilePicUrl!)',
                \(user.gender!),
                \(user.age!),
                '\(user.country!)',
                '\(user.city!)',
                '\(user.superPower!)',
                '\(user.accountType!)',
                '\(userId!)'
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
            }
            else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Update matched user account type by id.
    func updateMatchedUserAccountTypeById(matchedUserId: String!, accountType: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_MATCHED_USER) SET
            \(DBConstants.MATCHED_USER_ACCOUNT_TYPE)='\(accountType!)'
            WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'
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
            }
            else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Update matched user main profile pic url by id.
    func updateUserMainProfilePic(matchedUserId: String!, mainProfilePicUrl: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_MATCHED_USER) SET
            \(DBConstants.MATCHED_USER_MAIN_PROFILE_PIC_URL)='\(mainProfilePicUrl!)'
            WHERE \(DBConstants.MATCHED_USER_ID)='\(matchedUserId!)'
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
            }
            else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Saves new matched user profile pic.
    func insertMatchedUserProfilePic(matchedUserId: String!, picUrl: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MATCH_PROFILE_PICTURE)
            (
                \(DBConstants.PICTURE_MATCH_ID),
                \(DBConstants.MATCH_PROFILE_PIC_URL)
            )
            VALUES
            (
                '\(matchedUserId!)',
                '\(picUrl!)'
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
            }
            else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }

}
