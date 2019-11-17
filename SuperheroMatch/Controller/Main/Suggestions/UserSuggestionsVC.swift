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
        let piv = UIImageView(image: UIImage(named: "test10"))
        piv.contentMode = .scaleAspectFill
        piv.layer.cornerRadius = 10
        piv.clipsToBounds = true
        piv.tappable = true
        piv.layer.shadowColor = UIColor.black.cgColor
        piv.layer.shadowOpacity = 1
        piv.layer.shadowOffset = CGSize.zero
        piv.layer.shadowRadius = 10
        piv.layer.shadowPath = UIBezierPath(roundedRect: piv.bounds, cornerRadius: 10).cgPath
        
        return piv
    }()
    
    let userNameAge: UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Gotham Book", size: 22)
        userName.textAlignment = .center
        userName.textColor = .white
        
        return userName
    }()
    
    let city: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .center
        lbl.textColor = .white
        
        return lbl
    }()
    
    let superPower: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        lbl.textColor = .white
        
        return lbl
    }()
    
    lazy var dislikeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dislike")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var superPowerButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "superpower")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(superpowerTapped), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        return btn
    }()
    
    let gradientView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let suggestionDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var closeSuggestionDetailsViewButton: UIButton = {
        var btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(closeSuggestionDetailsViewTapped), for: .touchUpInside)
        
        return btn
    }()
    
    let suggestionNameAge: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    let suggestionCity: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 18)
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    let suggestionSuperPower: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Gotham Book", size: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.sizeToFit()
        
        return lbl
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
        profileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.callback = handleMainProfileImageTapped
        
        view.addSubview(gradientView)
        gradientView.anchor(top: nil, left: nil, bottom: profileImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: view.frame.width-10, height: 115)
        gradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width-10, height: 115)
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(superPower)
        superPower.anchor(top: nil, left: view.leftAnchor, bottom: profileImageView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width, height: 60)
        superPower.text = "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out."
        
        view.addSubview(city)
        city.anchor(top: nil, left: view.leftAnchor, bottom: superPower.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 25)
        city.text = "Somewhere"
        
        view.addSubview(userNameAge)
        userNameAge.anchor(top: nil, left: view.leftAnchor, bottom: city.topAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        userNameAge.text = "Superhero, 34"
        
        view.addSubview(dislikeButton)
        dislikeButton.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 50, height: 50)
        
        view.addSubview(superPowerButton)
        superPowerButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        superPowerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(likeButton)
        likeButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 50, height: 50)
        
        configureSuggestionDetailsView()
        
    }
    
    func configureSuggestionDetailsView() {
        
        view.addSubview(suggestionDetailsView)
        suggestionDetailsView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.40)
        suggestionDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        suggestionDetailsView.addSubview(closeSuggestionDetailsViewButton)
        closeSuggestionDetailsViewButton.anchor(top: suggestionDetailsView.topAnchor, left: nil, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 40, height: 40)
        
        suggestionDetailsView.addSubview(suggestionNameAge)
        suggestionNameAge.anchor(top: closeSuggestionDetailsViewButton.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        suggestionNameAge.text = "Superhero, 34"
        
        suggestionDetailsView.addSubview(suggestionCity)
        suggestionCity.anchor(top: suggestionNameAge.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 25)
        suggestionCity.text = "Somewhere"
        
        suggestionDetailsView.addSubview(suggestionSuperPower)
        suggestionSuperPower.anchor(top: suggestionCity.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: suggestionDetailsView.frame.width, height: 60)
        suggestionSuperPower.text = "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out."
        
        self.suggestionDetailsView.isHidden = true
    
    }
    
    func viewSlideInFromTopToBottom(view: UIView) {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
        
    }
    
    func viewSlideInFromBottomToTop(view: UIView) {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = .push
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
        
    }
    
    @objc func closeSuggestionDetailsViewTapped() {
        
        viewSlideInFromTopToBottom(view: self.suggestionDetailsView)
        self.suggestionDetailsView.isHidden = true
        
    }
    
    
    @objc func handleMainProfileImageTapped() {
        print("handleMainProfileImageTapped")
    }
    
    @objc func likeTapped() {
        print("likeTapped")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.profileImageView.image = UIImage(named: "test1")
            self.userNameAge.text = "Bar Zomer, 26"
            self.city.text = "Somewhere"
            self.superPower.text = "Amazing Eyes"
            
        }, completion: nil)
        
    }
    
    @objc func superpowerTapped() {
        
        self.suggestionDetailsView.isHidden = false
        viewSlideInFromBottomToTop(view: self.suggestionDetailsView)
        
    }
    
    @objc func dislikeTapped() {
        print("dislikeTapped")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.profileImageView.image = UIImage(named: "test3")
            self.userNameAge.text = "Isabella Buscemi, 26"
            self.city.text = "Somewhere"
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
