//
//  AppDelegate.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 17/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var verifyIdentityVC: VerifyIdentityVC?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        
//        let superheroMatchDB = SuperheroMatchDB.sharedDB
//        DispatchQueue.global().async {
//
//            var err = superheroMatchDB.createUserTable()
//
//            switch err {
//            case .NoError:
//                print("###########  superheroMatchDB.createUserTable err  ##############")
//                print("No error")
//                print("##################################")
//                break
//            case .SQLError:
//                print("###########  superheroMatchDB.createUserTable err  ##############")
//                print(err)
//                print("##################################")
//                break
//            default:
//                break
//            }
//
//            err = superheroMatchDB.insertDefaultUser()
//
//            switch err {
//            case .NoError:
//                print("###########  superheroMatchDB.insertDefaultUser err   ##############")
//                print("No error")
//                print("##################################")
//                break
//            case .SQLError:
//                print("###########  superheroMatchDB.insertDefaultUser err   ##############")
//                print(err)
//                print("##################################")
//                break
//            default:
//                break
//            }
//
//        }
        
        self.verifyIdentityVC = VerifyIdentityVC()
        
//        window = UIWindow()
//        window?.rootViewController = UINavigationController(rootViewController: self.verifyIdentityVC!)
        
        let mainTabVC = MainTabVC()
        window?.rootViewController = mainTabVC
        
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

        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in

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

