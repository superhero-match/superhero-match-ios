//
//  UserDB.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class UserDB {
    
    static let sharedDB = UserDB()
    
    // Fetch user.
    func getUser() -> (DBError, User?) {
        var err:DBError = .NoError
        var user: User? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_USER)
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
                    
                    let rawEmail = sqlite3_column_text(stmt, 1)
                    let email = String(cString:rawEmail!)
                    
                    let rawUserName = sqlite3_column_text(stmt, 2)
                    let userName = String(cString:rawUserName!)
                    
                    let rawSuperheroName = sqlite3_column_text(stmt, 3)
                    let superheroName = String(cString:rawSuperheroName!)
                    
                    let rawMainProfilePic = sqlite3_column_text(stmt, 4)
                    let mainProfilePic = String(cString:rawMainProfilePic!)
                    
                    let userGender = sqlite3_column_int(stmt, 5)
                    
                    let userLookingForGender = sqlite3_column_int(stmt, 6)
                    
                    let userAge = sqlite3_column_int(stmt, 7)
                    
                    let userLookingForMinAge = sqlite3_column_int(stmt, 8)
                    
                    let userLookingForMaxAge = sqlite3_column_int(stmt, 9)
                    
                    let userLookingForDistanceMax = sqlite3_column_int(stmt, 10)
                    
                    let rawDistanceUnit = sqlite3_column_text(stmt, 11)
                    let distanceUnit = String(cString:rawDistanceUnit!)
                    
                    let userLat = sqlite3_column_double(stmt, 12)
                    
                    let userLon = sqlite3_column_double(stmt, 13)
                    
                    let rawUserBirthDay = sqlite3_column_text(stmt, 14)
                    let userBirthDay = String(cString:rawUserBirthDay!)
                    
                    let rawUserCountry = sqlite3_column_text(stmt, 15)
                    let userCountry = String(cString:rawUserCountry!)
                    
                    let rawUserCity = sqlite3_column_text(stmt, 16)
                    let userCity = String(cString:rawUserCity!)
                    
                    let rawUserSuperPower = sqlite3_column_text(stmt, 17)
                    let userSuperPower = String(cString:rawUserSuperPower!)
                    
                    let rawUserAccountType = sqlite3_column_text(stmt, 18)
                    let userAccountType = String(cString:rawUserAccountType!)
                    
                    
                    user = User(userID: userId, email: email, name: userName, superheroName: superheroName, mainProfilePicUrl: mainProfilePic, profilePicsUrls: nil, gender: Int(userGender), lookingForGender: Int(userLookingForGender), age: Int(userAge), lookingForAgeMin: Int(userLookingForMinAge), lookingForAgeMax: Int(userLookingForMaxAge), lookingForDistanceMax: Int(userLookingForDistanceMax), distanceUnit: distanceUnit, lat: userLat, lon: userLon, birthday: userBirthDay, country: userCountry, city: userCity, superPower: userSuperPower, accountType: userAccountType)
                    
                }
                
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, user)
    }
    
    // Fetch user's id.
    func getUserId() -> (DBError, String?) {
        var err:DBError = .NoError
        var userId:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.U_ID) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.U_ID) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawId = sqlite3_column_text(stmt, 0)
                    userId = String(cString:rawId!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, userId)
    }
    
    // Fetch user's name.
    func getUserName() -> (DBError, String?) {
        var err:DBError = .NoError
        var userName:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_NAME) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_NAME) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch user's email.
    func getUserEmail() -> (DBError, String?) {
        var err:DBError = .NoError
        var email:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_EMAIL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_EMAIL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawEmail = sqlite3_column_text(stmt, 0)
                    email = String(cString:rawEmail!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, email)
    }
    
    // Fetch user's main profile picture url.
    func getUserMainProfilePicUrl() -> (DBError, String?) {
        var err:DBError = .NoError
        var userMainProfilePicUrl:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_MAIN_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_MAIN_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch all user's profile pics.
    func getUserProfilePicUrls(userId: String!) -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var urls:Array<String> = Array<String>()
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_USER_PROFILE_PICTURE) WHERE \(DBConstants.USER_ID)='\(userId!)'";
            
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
                    
                    let rawUrl = sqlite3_column_text(stmt, 3)
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
    
    // Fetch user's gender.
    func getUserGender() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var gender:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_GENDER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_GENDER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch user's gender.
    func getUserLookingForGender() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var lookingForGender:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_GENDER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_GENDER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    lookingForGender = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, lookingForGender)
    }
    
    // Fetch user's age.
    func getUserAge() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var age:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch user's looking for min age.
    func getUserLookingForMinAge() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var minAge:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MIN_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MIN_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    minAge = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, minAge)
    }
    
    // Fetch user's looking for max age.
    func getUserLookingForMaxAge() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var maxAge:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MAX_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MAX_AGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    maxAge = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, maxAge)
    }
    
    // Fetch user's looking for max age.
    func getUserLookingForMaxDistance() -> (DBError, Int64?) {
        var err:DBError = .NoError
        var maxDistance:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MAX_DISTANCE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LOOKING_FOR_MAX_DISTANCE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    maxDistance = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, maxDistance)
    }
    
    // Fetch user's selected distance unit.
    func getUserDistanceUnit() -> (DBError, String?) {
        var err:DBError = .NoError
        var distanceUnit:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_DISTANCE_UNIT) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_DISTANCE_UNIT) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawDistanceUnit = sqlite3_column_text(stmt, 0)
                    distanceUnit = String(cString:rawDistanceUnit!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, distanceUnit)
    }
    
    // Fetch user's latest known latitude.
    func getUserLat() -> (DBError, Double?) {
        var err:DBError = .NoError
        var lat:Double? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LATEST_LATITUDE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LATEST_LATITUDE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    lat = sqlite3_column_double(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, lat)
    }
    
    // Fetch user's latest known longitude.
    func getUserLon() -> (DBError, Double?) {
        var err:DBError = .NoError
        var lon:Double? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LATEST_LONGITUDE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_LATEST_LONGITUDE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    lon = sqlite3_column_double(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, lon)
    }
    
    // Fetch user's birthday.
    func getUserBirthday() -> (DBError, String?) {
        var err:DBError = .NoError
        var birthday:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_BIRTHDAY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_BIRTHDAY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawBirthday = sqlite3_column_text(stmt, 0)
                    birthday = String(cString:rawBirthday!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, birthday)
    }
    
    // Fetch user's country.
    func getUserCountry() -> (DBError, String?) {
        var err:DBError = .NoError
        var country:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_COUNTRY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_COUNTRY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch user's city.
    func getUserCity() -> (DBError, String?) {
        var err:DBError = .NoError
        var city:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_CITY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_CITY) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Fetch user's super power.
    func getUserSuperPower() -> (DBError, String?) {
        var err:DBError = .NoError
        var superPower:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_SUPER_POWER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_SUPER_POWER) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) //  WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Check if user is verified.
    func getUserIsVerified(userId: String!) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var isVerified:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_VERIFIED) FROM \(DBConstants.TABLE_USER) WHERE \(DBConstants.U_ID)='\(userId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_VERIFIED) FROM \(DBConstants.TABLE_USER) WHERE \(DBConstants.U_ID)='\(userId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    isVerified = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, isVerified)
    }
    
    // Check if user is logged in.
    func getUserIsLoggedIn(userId: String!) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var isLoggedIn:Int64? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_IS_LOGGED_IN) FROM \(DBConstants.TABLE_USER) WHERE \(DBConstants.U_ID)='\(userId!)'", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_IS_LOGGED_IN) FROM \(DBConstants.TABLE_USER) WHERE \(DBConstants.U_ID)='\(userId!)'", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    isLoggedIn = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, isLoggedIn)
    }
    
    // Fetch user created date.
    func getUserCreated() -> (DBError, String?) {
        var err:DBError = .NoError
        var created:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_CREATED) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_CREATED) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawCreated = sqlite3_column_text(stmt, 0)
                    created = String(cString:rawCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = superheroMatchDB.dbClose(db: db)
            
        }
        
        return (err, created)
    }
    
    // Fetch user's account type.
    func getUserAccountType() -> (DBError, String?) {
        var err:DBError = .NoError
        var accountType:String? = nil
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_ACCOUNT_TYPE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_ACCOUNT_TYPE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil) // WHERE \(DBConstants.USER_IS_LOGGED_IN)=1
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
    
    // Update default user.
    // This is called after registration is completed.
    func updateDefaultUser(user: User!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.U_ID)='\(user.userID!)',
            \(DBConstants.USER_EMAIL)='\(user.email!)',
            \(DBConstants.USER_NAME)='\(user.name!)',
            \(DBConstants.USER_MAIN_PROFILE_PIC_URL)='\(user.mainProfilePicUrl!)',
            \(DBConstants.USER_GENDER)=\(user.gender!),
            \(DBConstants.USER_LOOKING_FOR_GENDER)=\(user.lookingForGender!),
            \(DBConstants.USER_AGE)=\(user.age!),
            \(DBConstants.USER_LOOKING_FOR_MIN_AGE)=\(user.lookingForAgeMin!),
            \(DBConstants.USER_LOOKING_FOR_MAX_AGE)=\(user.lookingForAgeMax!),
            \(DBConstants.USER_LOOKING_FOR_MAX_DISTANCE)=\(user.lookingForDistanceMax!),
            \(DBConstants.USER_DISTANCE_UNIT)='\(user.distanceUnit!)',
            \(DBConstants.USER_LATEST_LATITUDE)=\(user.lat!),
            \(DBConstants.USER_LATEST_LONGITUDE)=\(user.lon!),
            \(DBConstants.USER_BIRTHDAY)='\(user.birthday!)',
            \(DBConstants.USER_COUNTRY)='\(user.country!)',
            \(DBConstants.USER_CITY)='\(user.city!)',
            \(DBConstants.USER_SUPER_POWER)='\(user.superPower!)',
            \(DBConstants.USER_ACCOUNT_TYPE)='\(user.accountType!)'
            WHERE \(DBConstants.U_ID)='default'
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
    
    // Saves new user.
    func insertUser(user: User!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            INSERT INTO \(DBConstants.TABLE_USER)
            (
            \(DBConstants.U_ID),
            \(DBConstants.USER_EMAIL),
            \(DBConstants.USER_NAME),
            \(DBConstants.USER_MAIN_PROFILE_PIC_URL),
            \(DBConstants.USER_GENDER),
            \(DBConstants.USER_LOOKING_FOR_GENDER),
            \(DBConstants.USER_AGE),
            \(DBConstants.USER_LOOKING_FOR_MIN_AGE),
            \(DBConstants.USER_LOOKING_FOR_MAX_AGE),
            \(DBConstants.USER_LOOKING_FOR_MAX_DISTANCE),
            \(DBConstants.USER_DISTANCE_UNIT),
            \(DBConstants.USER_LATEST_LATITUDE),
            \(DBConstants.USER_LATEST_LONGITUDE),
            \(DBConstants.USER_BIRTHDAY),
            \(DBConstants.USER_COUNTRY),
            \(DBConstants.USER_CITY),
            \(DBConstants.USER_SUPER_POWER),
            \(DBConstants.USER_ACCOUNT_TYPE)
            )
            VALUES
            (
            '\(user.userID!)',
            '\(user.email!)',
            '\(user.name!)',
            '\(user.mainProfilePicUrl!)',
            \(user.gender!),
            \(user.lookingForGender!),
            \(user.age!),
            \(user.lookingForAgeMin!),
            \(user.lookingForAgeMax!),
            \(user.lookingForDistanceMax!),
            '\(user.distanceUnit!)',
            \(user.lat!),
            \(user.lon!),
            '\(user.birthday!)',
            '\(user.country!)',
            '\(user.city!)',
            '\(user.superPower!)',
            '\(user.accountType!)'
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
    
    // Update default user id.
    func updateUserId(userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.U_ID)='\(userId!)'
            WHERE \(DBConstants.U_ID)='default'
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
    
    // Update default user id.
    func updateUserLatAndLon(lat: Double!, lon: Double!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_LATEST_LATITUDE)='\(lat!)',
            \(DBConstants.USER_LATEST_LONGITUDE)='\(lon!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user country and city.
    func updateUserCountryAndCity(country: String!, city: String!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_COUNTRY)='\(country!)',
            \(DBConstants.USER_CITY)='\(city!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user super power.
    func updateUserSuperPower(superPower: String!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_SUPER_POWER)='\(superPower!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user distance unit.
    func updateUserDistanceUnit(distanceUnit: String!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_DISTANCE_UNIT)='\(distanceUnit!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user looking for gender.
    func updateUserLookingForGender(lookingForGender: Int!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_LOOKING_FOR_GENDER)='\(lookingForGender!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user looking for min and max age range.
    func updateUserLookingForMinMaxAge(minAge: Int!, maxAge: Int!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_LOOKING_FOR_MIN_AGE)='\(minAge!)',
            \(DBConstants.USER_LOOKING_FOR_MAX_AGE)='\(maxAge!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user looking for max distance.
    func updateUserLookingForMaxDistance(lookingForMaxDistance: Int!, userId: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_LOOKING_FOR_MAX_DISTANCE)='\(lookingForMaxDistance!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user account type.
    func updateUserAccountType(userId: String!, accountType: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_ACCOUNT_TYPE)='\(accountType!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Update user main profile pic url.
    func updateUserMainProfilePic(userId: String!, mainProfilePicUrl: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_MAIN_PROFILE_PIC_URL)='\(mainProfilePicUrl!)'
            WHERE \(DBConstants.U_ID)='\(userId!)'
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
    
    // Saves new user profile piture.
    func insertProfilePic(userId: String!, picUrl: String!, picUri: String!) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let superheroMatchDB = SuperheroMatchDB.sharedDB
        
        if let db = superheroMatchDB.dbOpen() {
            let sql = """
            INSERT INTO \(DBConstants.TABLE_USER_PROFILE_PICTURE)
            (
            \(DBConstants.USER_ID),
            \(DBConstants.USER_PROFILE_PIC_URI),
            \(DBConstants.USER_PROFILE_PIC_URL)
            )
            VALUES
            (
            '\(userId!)',
            '\(picUri!)',
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
