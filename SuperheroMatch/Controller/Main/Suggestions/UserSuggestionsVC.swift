//
//  UserSuggestionsVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 12/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class UserSuggestionsVC: UIViewController, CLLocationManagerDelegate {
    
    var sgs: Suggestions?
    var uploadMatch: UploadMatch?
    var uploadChoice: Choice?
    var updateMessagingToken: UpdateMessagingToken?
    let userDB = UserDB.sharedDB
    let chatDB = ChatDB.sharedDB
    var user: User?
    var suggestion: Superhero?
    var suggestions : [Superhero] = []
    var superheroIds : [String] = []
    var retrievedSuperheroIds : [String] = []
    var currentSuggestion: Int = 0
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var timer = Timer()
    
    var latitude: Double?
    
    var longitude: Double?
    
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
    
    var suggestionprofileImagesVC: SuggestionProfileImagesVC?
    
    var noSuggestionsVC: NoSuggestionsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        self.navigationItem.title = "Suggestions"
        
        navigationController?.navigationBar.isTranslucent = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.suggestionprofileImagesVC = SuggestionProfileImagesVC(collectionViewLayout: layout)
        
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
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            let params = self.configureUpdateTokenRequestParameters(userId: self.user?.userID, token: result.token)
            self.updateToken(params: params)
          }
        }
        
        let params = configureSuggestionsRequestParameters()
        
        fetchSuggestions(params: params, isInitialRequest: true)
        
    }

    func configureUIForNoSuggestions() {
        
        view.addSubview(dislikeButton)
        dislikeButton.anchor(top: noSuggestionsVC!.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 50, height: 50)
        
        view.addSubview(superPowerButton)
        superPowerButton.anchor(top: noSuggestionsVC!.view.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        superPowerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(likeButton)
        likeButton.anchor(top: noSuggestionsVC!.view.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 50, height: 50)
        
    }
    
    func configureUIWithSuggestions() {
        
        view.addSubview(dislikeButton)
        dislikeButton.anchor(top: suggestionprofileImagesVC!.view.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 40, width: 50, height: 50)
        
        view.addSubview(superPowerButton)
        superPowerButton.anchor(top: suggestionprofileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        superPowerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(likeButton)
        likeButton.anchor(top: suggestionprofileImagesVC!.view.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 50, height: 50)
        
        configureSuggestionDetailsView()
        
    }
    
    func configureUI(hasSuggestions: Bool) {
        
        if !hasSuggestions {
            configureUIForNoSuggestions()
            
            return
        }
        
        configureUIWithSuggestions()
        
    }
    
    func configureSuggestionDetailsView() {
        
        view.addSubview(suggestionDetailsView)
        suggestionDetailsView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.40)
        suggestionDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        suggestionDetailsView.addSubview(closeSuggestionDetailsViewButton)
        closeSuggestionDetailsViewButton.anchor(top: suggestionDetailsView.topAnchor, left: nil, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 40, height: 40)
        
        suggestionDetailsView.addSubview(suggestionNameAge)
        suggestionNameAge.anchor(top: closeSuggestionDetailsViewButton.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        suggestionNameAge.text = self.suggestions.count > 0 ? self.suggestions[self.currentSuggestion].superheroName + " \(self.suggestions[self.currentSuggestion].age ?? 0)" : ""
        
        suggestionDetailsView.addSubview(suggestionCity)
        suggestionCity.anchor(top: suggestionNameAge.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 25)
        suggestionCity.text = self.suggestions.count > 0 ? self.suggestions[self.currentSuggestion].city : ""
        
        suggestionDetailsView.addSubview(suggestionSuperPower)
        suggestionSuperPower.anchor(top: suggestionCity.bottomAnchor, left: suggestionDetailsView.leftAnchor, bottom: nil, right: suggestionDetailsView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: suggestionDetailsView.frame.width, height: 60)
        suggestionSuperPower.text = self.suggestions.count > 0 ? self.suggestions[self.currentSuggestion].superpower : ""
        
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
    
    func configureNoSuggestionsVC() {
        
        self.noSuggestionsVC = NoSuggestionsVC()
        
        self.suggestionprofileImagesVC?.removeFromParent()
        self.suggestionDetailsView.removeFromSuperview()
        
        addChild(self.noSuggestionsVC!)
        view.addSubview(self.noSuggestionsVC!.view)
        self.noSuggestionsVC!.didMove(toParent: self)
        self.noSuggestionsVC!.view.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        self.noSuggestionsVC!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func configureSuggestionProfilePicVC(isInitialRequest: Bool) {
        
        self.noSuggestionsVC?.removeFromParent()
        
        if !isInitialRequest {
            self.suggestionprofileImagesVC?.removeFromParent()
        }
        
        self.suggestionprofileImagesVC!.loadedSuggestion = self.suggestions[self.currentSuggestion]
        
        addChild(suggestionprofileImagesVC!)
        view.addSubview(suggestionprofileImagesVC!.view)
        suggestionprofileImagesVC!.didMove(toParent: self)
        suggestionprofileImagesVC!.view.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width-10, height: view.frame.height * 0.70)
        suggestionprofileImagesVC!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        suggestionDetailsView.removeFromSuperview()
        
        configureSuggestionDetailsView()
        
        NotificationCenter.default.post(name: Notification.Name("LoadNextSuggestionNotification"), object: nil, userInfo: nil)
        
    }
    
    @objc func closeSuggestionDetailsViewTapped() {
        
        viewSlideInFromTopToBottom(view: self.suggestionDetailsView)
        self.suggestionDetailsView.isHidden = true
        
    }
    
    
    @objc func handleMainProfileImageTapped() {
        print("handleMainProfileImageTapped")
    }
    
    @objc func likeTapped() {
        
        if self.suggestions.count == 0 {
            return
        }
        
        let suggestion = self.suggestions[self.currentSuggestion]
        
        if suggestion.hasLikedMe {
            // Don't move to the next suggestions unless user choses to chat with match later.
            
            // 1. Insert match into local DB.
            let matchId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            
            let (dbErr, _) = self.chatDB.insertChat(chatId: matchId, chatName: suggestion.superheroName, matchedUserId: suggestion.userID, matchedUserProfilePicUrl: suggestion.mainProfilePicUrl)
            if case .SQLError = dbErr {
                print("###########  insertChat dbErr  ##############")
                print(dbErr)
            }

            // 2. Send match to server.
            let params = configureUploadMatchRequestParameters(matchId: matchId, superheroId: self.user?.userID, matchedSuperheroId: suggestion.userID)
            self.uploadMatch(params: params) 
            
            // 3. Show user it's amatch dialog.
            let itIsAMatchVC = ItIsAMatchVC()
            itIsAMatchVC.mainImageUrl = suggestion.mainProfilePicUrl
            navigationController?.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(itIsAMatchVC, animated: true)
            
        }
        
        
        if (self.suggestions.count - 1) > self.currentSuggestion {
            
            self.currentSuggestion += 1
            
            self.configureSuggestionProfilePicVC(isInitialRequest: false)
            
        } else {
            
            let params = self.configureSuggestionsRequestParameters()
            
            self.fetchSuggestions(params: params, isInitialRequest: false)
            
        }
        
        if !suggestion.hasLikedMe {
            let params = self.configureUploadChoiceRequestParameters(superheroID: self.user?.userID, chosenSuperheroID: suggestion.userID, choice: 1)
            self.uploadChoice(params: params, suggestion: suggestion)
        }
        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//
//
//        }, completion: nil)
        
    }
    
    @objc func superpowerTapped() {
        
        self.suggestionDetailsView.isHidden = false
        viewSlideInFromBottomToTop(view: self.suggestionDetailsView)
        
    }
    
    @objc func dislikeTapped() {
        
        if self.suggestions.count == 0 {
            return
        }
        
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//
//        }, completion: nil)
        
        let suggestion = self.suggestions[self.currentSuggestion]
        
        let params = self.configureUploadChoiceRequestParameters(superheroID: self.user?.userID, chosenSuperheroID: suggestion.userID, choice: 2)
        self.uploadChoice(params: params, suggestion: suggestion)
        
        if (self.suggestions.count - 1) > self.currentSuggestion {
            
            self.currentSuggestion += 1
            
            self.configureSuggestionProfilePicVC(isInitialRequest: false)
            
        } else {
            
            let params = self.configureSuggestionsRequestParameters()
            
            self.fetchSuggestions(params: params, isInitialRequest: false)
            
        }
        
    }
    
    func configureUpdateTokenRequestParameters(userId: String!, token: String!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["userId"] = userId
        params["token"] = token
        
        return params
        
    }
    
    func configureUploadChoiceRequestParameters(superheroID: String!, chosenSuperheroID: String!, choice: Int!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["superheroID"] = superheroID
        params["chosenSuperheroID"] = chosenSuperheroID
        params["choice"] = choice
        
        return params
        
    }
    
    func configureUploadMatchRequestParameters(matchId: String!, superheroId: String!, matchedSuperheroId: String!) -> [String: Any] {
        
        var params = [String: Any]()
        
        params["matchId"] = matchId
        params["superheroId"] = superheroId
        params["matchedSuperheroId"] = matchedSuperheroId
        
        return params
        
    }
    
    func configureSuggestionsRequestParameters() -> [String: Any] {
        
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
        
        // 1. Check if superherosIds is empty. If so, that means it is ES request.
        params["isEsRequest"] = false
        
        if superheroIds.count == 0 {
            params["isEsRequest"] = true
        }
        
        // 2. If superheroIds is not empty, then pop maximum first 10 ids from superheroIds
        // and put them in params --> superheroIds.
        var superherosToBeFetched : [String] = []
        var indicesToBeDeleted : [Int] = []
        
        if superheroIds.count > 0 {
            
            var index: Int = 0
            
            for superheroId in superheroIds {
                
                if superherosToBeFetched.count == ConstantRegistry.PAGE_SIZE {
                    break
                }
                
                superherosToBeFetched.append(superheroId)
                
                // After superhero id has been added to the list of ids to be fetched
                // it can be removed as there is no need to fetch the same suggestions.
                indicesToBeDeleted.append(index)
                
                index += 1
                
            }
            
            for _ in indicesToBeDeleted {
                superheroIds.remove(at: 0)
            }
            
        }
        
        params["superheroIds"] = superherosToBeFetched
        params["retrievedSuperheroIds"] = retrievedSuperheroIds
        
        
        print(params)
        
        return params
        
    }
    
    func fetchSuggestions(params: [String: Any], isInitialRequest: Bool!) {
        
        self.sgs = Suggestions()
        self.sgs!.suggestions(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let suggestionsResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try SuggestionsResponse(json: suggestionsResponse as! [String : AnyObject])
                
                if response.status != 200  {
                    print("Error!")
                    
                    return
                }
                
                // These are ids of cached suggestions. When the next request to fetch more
                // suggestions will be made, maximum 10 of these ids will be passed to request
                // so that the next batch of suggestions could be retrieved.
                for superheroId in response.superheroIds {
                    self.superheroIds.append(superheroId)
                }
                
                for suggestion in response.suggestions {
                    
                    // These are ids of the suggestions that were already retrieved and viewed.
                    // So if user will make more requests where all the cached suggestions
                    // were shown and the request to the lasticsearch will have to be made again
                    // the users who were shown will be excluded from Elasticsearch results.
                    self.retrievedSuperheroIds.append(suggestion.userID)
                    
                    // These are the actual suggestions that will be shown to the user.
                    self.suggestions.append(suggestion)
                    
                }
                
                if response.suggestions.count > 0 {
                    
                    if !isInitialRequest {
                        self.currentSuggestion += 1
                    }
                    
                    self.configureSuggestionProfilePicVC(isInitialRequest: isInitialRequest)
                    
                } else {
                    self.configureNoSuggestionsVC()
                }
                
                if isInitialRequest {
                    self.configureUI(hasSuggestions: response.suggestions.count > 0)
                }
                
                
            } catch {
                // TO-DO: Show alert that something went wrong
                print("catch in fetchSuggestions")
            }
        }
        
    }
    
    func uploadChoice(params: [String: Any], suggestion: Superhero!) {
        
        self.uploadChoice = Choice()
        self.uploadChoice!.uploadChoice(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let uploadChoiceResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try ChoiceResponse(json: uploadChoiceResponse as! [String : AnyObject])
                
                if response.status != 200  {
                    print("Error!")
                    
                    return
                }
                
                if response.isMatch {
                    
                    // 1. Insert match into local DB.
                    let matchId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                    
                    let (dbErr, _) = self.chatDB.insertChat(chatId: matchId, chatName: suggestion.superheroName, matchedUserId: suggestion.userID, matchedUserProfilePicUrl: suggestion.mainProfilePicUrl)
                    if case .SQLError = dbErr {
                        print("###########  insertChat dbErr  ##############")
                        print(dbErr)
                    }

                    // 2. Send match to server.
                    let params = self.configureUploadMatchRequestParameters(matchId: matchId, superheroId: self.user?.userID, matchedSuperheroId: suggestion.userID)
                    self.uploadMatch(params: params)
                    
                    // 3. Show user it's amatch dialog.
                    let itIsAMatchVC = ItIsAMatchVC()
                    itIsAMatchVC.mainImageUrl = suggestion.mainProfilePicUrl
                    self.navigationController?.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(itIsAMatchVC, animated: true)

                }
                
            } catch {
                // TO-DO: Show alert that something went wrong
                print("catch in uploadChoice")
            }
        }
        
    }
    
    func uploadMatch(params: [String: Any]) {
        
        self.uploadMatch = UploadMatch()
        self.uploadMatch!.uploadMatch(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let uploadMatchResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = uploadMatchResponse as! [String : Int]
                
                if response["status"] != 200  {
                    print("Error!")
                    
                    return
                }
                
            } catch {
                // TO-DO: Show alert that something went wrong
                print("catch in uploadMatch")
            }
        }
        
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
                // TO-DO: Show alert that something went wrong
                print("catch in updateTokenResponse")
            }
        }
        
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
                    print(error as Any)
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
