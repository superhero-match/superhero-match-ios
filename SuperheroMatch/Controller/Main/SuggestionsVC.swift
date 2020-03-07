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
import CoreLocation

private let reuseIdentifier = "Cell"

class SuggestionsVC: UICollectionViewController , UICollectionViewDelegateFlowLayout, SuggestionCellDelegate, CLLocationManagerDelegate {
    
    var suggestions : [User] = []
    var sgs: Suggestions?
    let userDB = UserDB.sharedDB
    var user: User?
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var timer = Timer()
    
    var latitude: Double?
    
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        self.collectionView?.backgroundColor = .white
        
        // Register cell classes
       //  self.collectionView!.register(SuggestionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView?.backgroundColor = .white
        self.navigationItem.title = "Suggestions"
        
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
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)// as! SuggestionCell
        
        // cell.imageURL = user?.profilePicsUrls[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let profileVC = ProfileVC(collectionViewLayout: UICollectionViewFlowLayout())

        profileVC.userToLoadFromAnotherVC = suggestions[indexPath.row]

        navigationController?.pushViewController(profileVC, animated: true)

    }
    
//    func handleImageTapped(for cell: SuggestionCell) {
//        print("handleImageTapped")
//    }
//
//    func handleUsernameTapped(for cell: SuggestionCell){
//        print("handleUsernameTapped")
//    }
//
    
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
        
        let suggestion1 = User(userID: "id1", email: nil, name: "Superhero 1", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 1", accountType: "FREE")
        suggestions.append(suggestion1)
        
        let suggestion2 = User(userID: "id2", email: nil, name: "Superhero 2", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 2", accountType: "FREE")
        suggestions.append(suggestion2)
        
        let suggestion3 = User(userID: "id3", email: nil, name: "Superhero 3", superheroName: "Superhero 1", mainProfilePicUrl: "main profile pic", profilePicsUrls: ["pic 1", "pic 2"], gender: 1, lookingForGender: nil, age: 25, lookingForAgeMin: nil, lookingForAgeMax: nil, lookingForDistanceMax: nil, distanceUnit: nil, lat: nil, lon: nil, birthday: nil, country: nil, city: nil, superPower: "Super Power 3", accountType: "FREE")
        suggestions.append(suggestion3)
        
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
