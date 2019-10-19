//
//  UserSuggestionsVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 12/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import CoreLocation

class UserSuggestionsVC: UIViewController, CLLocationManagerDelegate {
    
    var sgs: Suggestions?
    let userDB = UserDB.sharedDB
    var user: User?
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var timer = Timer()
    
    var latitude: Double?
    
    var longitude: Double?
    
    let profileImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "test"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.tappable = true
        
        return piv
    }()
    
    let userName: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 22)
        userName.textAlignment = .center
        
        return userName
    }()
    
    let genderAge: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 16)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    let superPowerImageView: UIImageView = {
        let piv = UIImageView(image: UIImage(named: "superpower"))
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        
        return piv
    }()
    
    let superPower: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .left
        lbl.text = "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out."
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        
        return lbl
    }()
    
    lazy var dislikeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dislike")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Suggestions"
        
        navigationController?.navigationBar.isTranslucent = false
        
        configureUI()
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        if user != nil {
            self.user = user
        }
        
        locationManager.delegate = self
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.startUpdatingLocation()
        
        timer.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            
        }
        
        fetchSuggestions()
        
    }
    
    func configureUI() {
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height * 0.5)
        profileImageView.callback = handleMainProfileImageTapped
        
        view.addSubview(userName)
        userName.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(genderAge)
        genderAge.anchor(top: userName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 25)
        
        userName.text = "Superhero"
        genderAge.text = "Gender, Age"
        
        view.addSubview(superPowerImageView)
        superPowerImageView.anchor(top: genderAge.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        view.addSubview(superPower)
        superPower.anchor(top: genderAge.bottomAnchor, left: superPowerImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 80)
        
        view.addSubview(dislikeButton)
        dislikeButton.anchor(top: superPower.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
        
        view.addSubview(likeButton)
        likeButton.anchor(top: superPower.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 40, height: 40)
        
    }
    
    @objc func handleMainProfileImageTapped() {
        print("handleMainProfileImageTapped")
    }
    
    @objc func likeTapped() {
        print("likeTapped")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.profileImageView.image = UIImage(named: "barzomer")
            self.userName.text = "Bar Zomer"
            self.genderAge.text = "Female, 21"
            self.superPower.text = "Amazing Eyes"
            
        }, completion: nil)
        
    }
    
    @objc func dislikeTapped() {
        print("dislikeTapped")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.profileImageView.image = UIImage(named: "missbuscemi")
            self.userName.text = "Isabella Buscemi"
            self.genderAge.text = "Female, 21"
            self.superPower.text = "Bootylicious"
            
        }, completion: nil)
        
    }
    
    func fetchSuggestions() {
        
        var params = [String: Any]()
        
        params["id"] = self.user?.userID
        params["lookingForGender"] = self.user?.lookingForGender
        params["gender"] = self.user?.gender
        params["lookingForAgeMin"] = self.user?.lookingForAgeMin
        params["lookingForAgeMax"] = self.user?.lookingForAgeMax
        params["maxDistance"] = self.user?.lookingForDistanceMax
        params["distanceUnit"] = self.user?.distanceUnit
        params["lat"] = self.user?.lat
        params["lon"] = self.user?.lon
        params["offset"] = 0
        params["size"] = 10
        
        print(params)
        
        
        //        self.sgs = Suggestions()
        //        self.sgs!.suggestions(params: params) { json, error in
        //            do {
        //
        //                //Convert to Data
        //                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
        //
        //                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
        //                let suggestionsResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
        //
        //                let response = try SuggestionsResponse(json: suggestionsResponse as! [String : AnyObject])
        //
        //                if response.status != 200  {
        //                    print("Error!")
        //                } else {
        //                    print("All good!")
        //                }
        //
        //            } catch {
        //                print("catch")
        //            }
        //        }
        
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let (dbErr, userId) = self.userDB.getUserId()
            if case .SQLError = dbErr {
                print("###########  getUserId dbErr  ##############")
                print(dbErr)
            }
            
            let (latLonErr, _) = self.userDB.updateUserLatAndLon(lat: location.coordinate.latitude, lon: location.coordinate.longitude, userId: userId)
            if case .SQLError = latLonErr {
                print("###########  updateUserLatAndLon latLonErr  ##############")
                print(latLonErr)
            }
            
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                if (error != nil) {
                    print("Error in reverseGeocode")
                    print(error)
                }
                
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    
                    let (ccErr, _) = self.userDB.updateUserCountryAndCity(country: placemark.country!, city: placemark.locality!, userId: userId)
                    if case .SQLError = ccErr {
                        print("###########  updateUserCountryAndCity ccErr  ##############")
                        print(ccErr)
                    }
                }
            })
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been denied access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to submit offline report you need to enable your location services.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: self.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func grabit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    
}
