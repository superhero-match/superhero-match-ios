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

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var verifyIdentityVC: VerifyIdentityVC?
    let gcmMessageIDKey = "gcm.message_id"
    var updateMessagingToken: UpdateMessagingToken?
    var getMatch: GetMatch?
    let userDB = UserDB.sharedDB
    let superheroMatchDB = SuperheroMatchDB.sharedDB
    let chatDB = ChatDB.sharedDB
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow()
        
        DispatchQueue.global().async {
            
            let (err, dbVersion) = self.superheroMatchDB.getDBVersion()
            if case .SQLError = err {
                print("###########  getDBVersion err  ##############")
                print(err)
            }
            
            switch dbVersion {
            case nil:
                print("###########  database does not exist -> create database  ##############")
                let dberr = self.superheroMatchDB.createDB()
                if case .SQLError = dberr {
                    print(dberr)
                }
                
                break
            case DBConstants.DB_VERSION:
                print("###########  the same database version -> all good  ##############")
                
                break
            default:
                print("###########  different database version -> database needs an upgarde  ##############")
                
                break
            }
            
        }
        
        let (uerr, userId) = userDB.getUserId()
        if case .SQLError = uerr {
            print("###########  getUserId uerr  ##############")
            print(uerr)
        }
        
        if userId == "default" || userId == nil {
            self.verifyIdentityVC = VerifyIdentityVC()
            self.window?.rootViewController = UINavigationController(rootViewController: self.verifyIdentityVC!)
        } else {
            let mainTabVC = MainTabVC()
            self.window?.rootViewController = mainTabVC
        }
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // User is signed in
            print(user.profile.email!)
            print(user.profile.name!)
            
            UserDefaults.standard.set(user.profile.email!, forKey: "email")
            UserDefaults.standard.set(user.profile.name!, forKey: "name")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: Notification.Name("SuccessfulSignInNotification"), object: nil, userInfo: nil)
            
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func configureGetMatchRequestParameters(superheroId: String!, matchedSuperheroId: String!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["superheroId"] = superheroId
        params["matchedSuperheroId"] = matchedSuperheroId
        
        return params
        
    }
    
    
    func getMatch(params: [String: Any]) {
        
        self.getMatch = GetMatch()
        self.getMatch!.getMatch(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let getMatchResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try GetMatchResponse(json: getMatchResponse as! [String : Any])

                if response.status != 200 {
                    print("Something went wrong!")
                    
                    return
                }
                
                print("All good!")
                let matchId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                
                let (err, _) = self.chatDB.insertChat(chatId: matchId, chatName: response.match!.superheroName, matchedUserId: response.match!.userID, matchedUserProfilePicUrl: response.match!.mainProfilePicUrl)
                if case .SQLError = err {
                    print("###########  insertChat uerr  ##############")
                    print(err)
                    
                    return
                }
                
                // Display notification
                let center = UNUserNotificationCenter.current()
                
                let content = UNMutableNotificationContent()
                content.title = "It's a match!"
                content.body = "You matched with \(response.match!.superheroName ?? "a user.")"
                content.sound = .default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
                
                center.add(request, withCompletionHandler: {(error) in
                    
                    if error != nil {
                        print("Error = \(error?.localizedDescription ?? "error notification")")
                    }
                    
                })
                                                   
                
            } catch {
                print("catch in getMatch")
            }
        }
        
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("didReceiveRemoteNotification without completion handler")
        print(userInfo)
        
        switch userInfo["data_type"] as? String {
        case "new_match":
            let matchedSuperheroId = userInfo["superhero_id"] as? String
            
            let (uerr, userId) = self.userDB.getUserId()
            if case .SQLError = uerr {
                print("###########  getUserId uerr  ##############")
                print(uerr)
                
                return
            }
            
            let params = configureGetMatchRequestParameters(superheroId: userId, matchedSuperheroId: matchedSuperheroId)
            
            self.getMatch(params: params)
        case "delete_match":
            let matchedSuperheroId = userInfo["superhero_id"] as? String
            
            let (err, chat) = self.chatDB.getChatByMatchedUserId(matchedUserId: matchedSuperheroId)
            if case .SQLError = err {
                print("###########  getUserId getChatIdByChatName  ##############")
                print(err)
                
                return
            }
            
            let (cerr, _) = self.chatDB.deleteChatById(chatId: chat?.chatID)
            if case .SQLError = cerr {
                print("###########  getUserId deleteChatById  ##############")
                print(cerr)
                
                return
            }
            
        default:
            print("###########  unknown message  ##############")
        }

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("didReceiveRemoteNotification with completion handler")
        print(userInfo)
        
        switch userInfo["data_type"] as? String {
        case "new_match":
            let matchedSuperheroId = userInfo["superhero_id"] as? String
            
            let (uerr, userId) = self.userDB.getUserId()
            if case .SQLError = uerr {
                print("###########  getUserId uerr  ##############")
                print(uerr)
                
                return
            }
            
            let params = configureGetMatchRequestParameters(superheroId: userId, matchedSuperheroId: matchedSuperheroId)
            
            self.getMatch(params: params)
        case "delete_match":
            let matchedSuperheroId = userInfo["superhero_id"] as? String
            
            let (err, chat) = self.chatDB.getChatByMatchedUserId(matchedUserId: matchedSuperheroId)
            if case .SQLError = err {
                print("###########  getUserId getChatIdByChatName  ##############")
                print(err)
                
                return
            }
            
            let (cerr, _) = self.chatDB.deleteChatById(chatId: chat?.chatID)
            if case .SQLError = cerr {
                print("###########  getUserId deleteChatById  ##############")
                print(cerr)
                
                return
            }
            
        default:
            print("###########  unknown message  ##############")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("userNotificationCenter with UNNotificationPresentationOptions completion handler")
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print("userNotificationCenter without UNNotificationPresentationOptions completion handler")
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    func configureUpdateTokenRequestParameters(userId: String!, token: String!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["superheroID"] = userId
        params["token"] = token
        
        return params
        
    }
    
    func updateToken(params: [String: Any]) {
        
        self.updateMessagingToken = UpdateMessagingToken()
        self.updateMessagingToken!.updateMessagingToken(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let updateTokenResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = updateTokenResponse as! [String : Int]
                
                if response["status"] != 200  {
                    print("Error!")
                    
                    return
                }
                
            } catch {
                print("catch in updateTokenResponse")
            }
        }
        
    }
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let userDB = UserDB.sharedDB
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        let (dbErr, user) = userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        self.updateToken(params: self.configureUpdateTokenRequestParameters(userId: user?.userID, token: fcmToken))
        
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
        switch remoteMessage.appData["data_type"] as? String {
        case "new_match":
            let matchedSuperheroId = remoteMessage.appData["superhero_id"] as? String
            
            let (uerr, userId) = self.userDB.getUserId()
            if case .SQLError = uerr {
                print("###########  getUserId uerr  ##############")
                print(uerr)
                
                return
            }
            
            self.getMatch(params: configureGetMatchRequestParameters(superheroId: userId, matchedSuperheroId: matchedSuperheroId))
        case "delete_match":
            let matchedSuperheroId = remoteMessage.appData["superhero_id"] as? String
            
            let (err, chat) = self.chatDB.getChatByMatchedUserId(matchedUserId: matchedSuperheroId)
            if case .SQLError = err {
                print("###########  getUserId getChatIdByChatName  ##############")
                print(err)
                
                return
            }
            
            let (cerr, _) = self.chatDB.deleteChatById(chatId: chat?.chatID)
            if case .SQLError = cerr {
                print("###########  getUserId deleteChatById  ##############")
                print(cerr)
                
                return
            }
            
        default:
            print("###########  unknown message  ##############")
        }
    }
    // [END ios_10_data_message]
}

