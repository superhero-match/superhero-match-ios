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

class DBConstants {
    
    // Version table columns
    static let TABLE_VERSION = "version"
    static let VERSION = "version"
    static let DB_VERSION:Int64 = 1
    
    static let TABLE_CREATE_VERSION = """
        CREATE TABLE IF NOT EXISTS \(DBConstants.TABLE_VERSION) (\(DBConstants.VERSION) INTEGER)
    """
    
    //=======================================================================================================================
    // user table
    //=======================================================================================================================
    static let TABLE_USER = "user"
    static let U_ID = "_id"
    static let USER_EMAIL = "user_email"
    static let USER_NAME = "user_name"
    static let SUPERHERO_NAME = "superhero_name"
    static let USER_MAIN_PROFILE_PIC_URL = "user_main_profile_pic_url"
    static let USER_GENDER = "user_gender"
    static let USER_LOOKING_FOR_GENDER = "user_looking_for_gender"
    static let USER_AGE = "user_age"
    static let USER_LOOKING_FOR_MIN_AGE = "user_looking_for_min_age"
    static let USER_LOOKING_FOR_MAX_AGE = "user_looking_for_max_age"
    static let USER_LOOKING_FOR_MAX_DISTANCE = "user_looking_for_max_distance"
    static let USER_DISTANCE_UNIT = "user_distance_unit"
    static let USER_LATEST_LATITUDE = "user_latest_latitude"
    static let USER_LATEST_LONGITUDE = "user_latest_longitude"
    static let USER_BIRTHDAY = "user_birthday"
    static let USER_COUNTRY = "user_country"
    static let USER_CITY = "user_city"
    static let USER_SUPER_POWER = "user_super_power"
    static let USER_ACCOUNT_TYPE = "user_account_type"
    static let USER_VERIFIED = "user_verified"
    static let USER_IS_LOGGED_IN = "user_is_logged_in"
    static let USER_CREATED = "user_created"
    
    // SQL to create table user
    static let TABLE_CREATE_USER =
    "CREATE TABLE IF NOT EXISTS " + TABLE_USER + " (" +
    U_ID + " TEXT PRIMARY KEY, " +
    USER_EMAIL + " TEXT NOT NULL," +
    USER_NAME + " TEXT NOT NULL," +
    SUPERHERO_NAME + " TEXT NOT NULL," +
    USER_MAIN_PROFILE_PIC_URL + " TEXT," +
    USER_GENDER + " INTEGER NOT NULL," +
    USER_LOOKING_FOR_GENDER + " INTEGER NOT NULL," +
    USER_AGE + " INTEGER NOT NULL," +
    USER_LOOKING_FOR_MIN_AGE + " INTEGER NOT NULL," +
    USER_LOOKING_FOR_MAX_AGE + " INTEGER NOT NULL," +
    USER_LOOKING_FOR_MAX_DISTANCE + " INTEGER NOT NULL," +
    USER_DISTANCE_UNIT + " TEXT NOT NULL," +
    USER_LATEST_LATITUDE + " REAL NOT NULL, " +
    USER_LATEST_LONGITUDE + " REAL NOT NULL, " +
    USER_BIRTHDAY + " TEXT NOT NULL," +
    USER_COUNTRY + " TEXT NOT NULL," +
    USER_CITY + " TEXT NOT NULL," +
    USER_SUPER_POWER + " TEXT NOT NULL, " +
    USER_ACCOUNT_TYPE + " TEXT NOT NULL," +
    USER_VERIFIED + " INTEGER, " +
    USER_IS_LOGGED_IN + " INTEGER, " +
    USER_CREATED + " TEXT default CURRENT_TIMESTAMP)"
    
    // insert default user
    static let INSERT_DEFAULT_USER = "INSERT INTO " + TABLE_USER +
    " VALUES ( 'default', 'default@default.com', 'defaultName', 'defaultSuperheroName', 'defaultUrl', 1, 2, 34, 18, 65, 100, 'km', 0.0, 0.0," +
    "'30-05-1985', 'Country', 'City', 'Super Power', 'FREE', 0, 0, '17-07-2019')";
    
    //=======================================================================================================================
    // user profile picture table
    //=======================================================================================================================
    static let TABLE_USER_PROFILE_PICTURE = "user_profile_picture"
    static let USER_PROFILE_PICTURE_ID = "_id"
    static let USER_ID = "user_id"
    static let USER_PROFILE_PIC_URI = "profile_pic_uri"
    static let USER_PROFILE_PIC_URL = "profile_pic_url"
    
    // SQL to create table user
    static let TABLE_CREATE_USER_PROFILE_PICTURE =
    "CREATE TABLE IF NOT EXISTS " + TABLE_USER_PROFILE_PICTURE + " (" +
    USER_PROFILE_PICTURE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
    USER_ID + " TEXT NOT NULL," +
    USER_PROFILE_PIC_URI + " TEXT NOT NULL, " +
    USER_PROFILE_PIC_URL + " TEXT NOT NULL, " +
    " FOREIGN KEY(" + USER_ID + ") REFERENCES " + TABLE_USER + "(" + U_ID + ")" +
    ")"
    
    //=======================================================================================================================
    // chat table
    //=======================================================================================================================
    static let TABLE_CHAT = "chat"
    static let CHAT_ID = "_id"
    static let CHAT_NAME = "chat_name"
    static let CHAT_MATCHED_USER_ID = "chat_matched_user_id"
    static let CHAT_MATCHED_USER_MAIN_PROFILE_PIC = "chat_matched_user_main_profile_pic"
    static let CHAT_CREATED = "chat_created"
    
    // SQL to create table chat
    static let TABLE_CREATE_MATCH_CHAT =
    "CREATE TABLE IF NOT EXISTS " + TABLE_CHAT + " (" +
    CHAT_ID + " TEXT PRIMARY KEY, " +
    CHAT_NAME + " TEXT NOT NULL," +
    CHAT_MATCHED_USER_ID + " TEXT NOT NULL," +
    CHAT_MATCHED_USER_MAIN_PROFILE_PIC + " TEXT NOT NULL," +
    CHAT_CREATED + " TEXT default CURRENT_TIMESTAMP " +
    ")"
    
    
    //=======================================================================================================================
    // match chat message table
    //=======================================================================================================================
    static let TABLE_MESSAGE = "message"
    static let MESSAGE_ID = "_id"
    static let MESSAGE_CHAT_ID = "message_chat_id"
    static let MESSAGE_SENDER_ID = "message_sender_id"
    static let MESSAGE_RECEIVER_ID = "message_receiver_id"
    static let TEXT_MESSAGE = "text_message"
    static let MESSAGE_HAS_BEEN_READ = "message_has_been_read"
    static let MESSAGE_UUID = "message_uuid"
    static let MESSAGE_CREATED = "match_message_created"

    // SQL to create table message
    static let TABLE_CREATE_CHAT_MESSAGE =
    "CREATE TABLE IF NOT EXISTS " + TABLE_MESSAGE + " (" +
    MESSAGE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
    MESSAGE_CHAT_ID + " TEXT NOT NULL," +
    MESSAGE_SENDER_ID + " TEXT NOT NULL," +
    MESSAGE_RECEIVER_ID + " TEXT NOT NULL," +
    TEXT_MESSAGE + " TEXT," +
    MESSAGE_HAS_BEEN_READ + " INTEGER default 0," +
    MESSAGE_UUID + " TEXT NOT NULL UNIQUE," +
    MESSAGE_CREATED + " TEXT default CURRENT_TIMESTAMP , " +
    " FOREIGN KEY(" + MESSAGE_CHAT_ID + ") REFERENCES " + TABLE_CHAT + "(" + CHAT_ID + ") " +
    ")"
    
    
    //=======================================================================================================================
    // message queue table
    //=======================================================================================================================
    static let TABLE_MESSAGE_QUEUE = "message_queue"
    static let MESSAGE_QUEUE_ITEM_ID = "_id"
    static let MESSAGE_QUEUE_MESSAGE_UUID = "message_queue_message_uuid"
    static let MESSAGE_QUEUE_MESSAGE_RECEIVER_ID = "message_queue_message_receiver_id"
    
    // SQL to create table text_message
    static let TABLE_CREATE_MESSAGE_QUEUE =
    "CREATE TABLE IF NOT EXISTS " + TABLE_MESSAGE_QUEUE + " (" +
    MESSAGE_QUEUE_ITEM_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
    MESSAGE_QUEUE_MESSAGE_UUID + " TEXT NOT NULL UNIQUE," +
    MESSAGE_QUEUE_MESSAGE_RECEIVER_ID + " INTEGER NOT NULL," +
    " FOREIGN KEY(" + MESSAGE_QUEUE_MESSAGE_UUID + ") REFERENCES " + TABLE_MESSAGE + "(" + MESSAGE_UUID + ") " +
    ")"
    
    
    //=======================================================================================================================
    // retrieved offline message uuid table
    //=======================================================================================================================
    static let TABLE_RETRIEVED_OFFLINE_MESSAGE_UUID = "retrieved_offline_message_uuid"
    static let RETRIEVED_OFFLINE_MESSAGE_UUID_ID = "_id"
    static let RETRIEVED_OFFLINE_MESSAGE_UUID = "retrieved_offline_message_uuid_uuid"
    
    // SQL to create table retrieved offline message
    static let TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID =
    "CREATE TABLE IF NOT EXISTS " + TABLE_RETRIEVED_OFFLINE_MESSAGE_UUID + " (" +
    RETRIEVED_OFFLINE_MESSAGE_UUID_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
    RETRIEVED_OFFLINE_MESSAGE_UUID + " TEXT NOT NULL UNIQUE," +
    " FOREIGN KEY(" + RETRIEVED_OFFLINE_MESSAGE_UUID + ") REFERENCES " + TABLE_MESSAGE + "(" + MESSAGE_UUID + ")" +
    ")"
    
    
    //=======================================================================================================================
    // received online message table
    //=======================================================================================================================
    static let TABLE_RECEIVED_ONLINE_MESSAGE = "received_online_message"
    static let RECEIVED_ONLINE_MESSAGE_ID = "_id"
    static let RECEIVED_ONLINE_MESSAGE_UUID = "received_online_message_uuid"
    
    // SQL to create table text_message
    static let TABLE_CREATE_RECEIVED_ONLINE_MESSAGE =
    "CREATE TABLE IF NOT EXISTS " + TABLE_RECEIVED_ONLINE_MESSAGE + " (" +
    RECEIVED_ONLINE_MESSAGE_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
    RECEIVED_ONLINE_MESSAGE_UUID + " TEXT NOT NULL UNIQUE," +
    " FOREIGN KEY(" + RECEIVED_ONLINE_MESSAGE_UUID + ") REFERENCES " + TABLE_MESSAGE + "(" + MESSAGE_UUID + ")" +
    ")"
    
}
