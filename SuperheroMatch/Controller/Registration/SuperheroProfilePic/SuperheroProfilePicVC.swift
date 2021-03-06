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
import SocketIO
import MBProgressHUD

class SuperheroProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageIsSelected: Bool!
    var register: Register?
    var user: User?
    var userID: String!
    var userMainProfilePicURL: String!
    let userDB = UserDB.sharedDB
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    let superheroProfilePicLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please add your profile picture"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let selectPicBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "user_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleSelectPic), for: .touchUpInside)
        
        return btn
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        return btn
    }()
    
    let previousBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Previous", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        
        return btn
    }()
    
    let termsAndPoliciesBtn: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "MWSOFT Copyright 2019.  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Terms & Policies", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        // hide nav bar
        navigationController?.navigationBar.isHidden = true
        
        userID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        
        view.addSubview(superheroProfilePicLabel)
        superheroProfilePicLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(selectPicBtn)
        selectPicBtn.anchor(top: superheroProfilePicLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 175, height: 175)
        selectPicBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureComponents()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        register = Register()
        
        self.manager = SocketManager(socketURL: URL(string: "\(ConstantRegistry.BASE_SERVER_URL)\(ConstantRegistry.SUPERHERO_REGISTER_MEDIA_PORT)")!, config: [.log(true), .forceWebsockets(true), .secure(true), .selfSigned(true), .sessionDelegate(CustomSessionDelegate())])
        
        self.socket = self.manager.defaultSocket
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        self.socket.on(ConstantRegistry.MAIN_PROFILE_PICTURE_URL) {[weak self] data, ack in
            
            MBProgressHUD.hide(for: self!.view, animated: true)
            
            if let url = data[0] as? String {
                self!.userMainProfilePicURL = url
            }
            
        }
        
        switch self.socket.status {
        case SocketIOStatus.connected:
            print("socket already connected")
        case SocketIOStatus.connecting:
            print("socket is connecting")
        case SocketIOStatus.disconnected:
            print("socket is disconnected")
            print("###########  self.socket.connect()  ##############")
            self.socket.connect()
        case SocketIOStatus.notConnected:
            print("socket is notConnected")
            print("###########  self.socket.connect()  ##############")
            self.socket.connect()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Selected image
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            return
        }
        
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        // Configure selectPicBtn with selected image
        selectPicBtn.layer.cornerRadius = selectPicBtn.frame.width / 2
        selectPicBtn.layer.masksToBounds = true
        selectPicBtn.layer.borderColor = UIColor.black.cgColor
        selectPicBtn.layer.borderWidth = 1
        selectPicBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let imageData: Data = profileImage.pngData()!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        self.socket.emit(ConstantRegistry.ON_UPLOAD_MAIN_PROFILE_PICTURE, userID, strBase64)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func configureComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [nextBtn, previousBtn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: selectPicBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }
    
    @objc func handleSelectPic() {
        
        // Configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // present image picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    fileprivate func configureRegisterRequest() -> [String: Any] {
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
        let name = UserDefaults.standard.string(forKey: "name") ?? ""
        
        let superheroName = UserDefaults.standard.string(forKey: "superheroName") ?? ""
        
        let age = UserDefaults.standard.integer(forKey: "age")
        
        let birthday = UserDefaults.standard.string(forKey: "birthday") ?? ""
        
        let gender = UserDefaults.standard.integer(forKey: "gender")
        
        let favoriteGender = UserDefaults.standard.integer(forKey: "favoriteGender")
        
        let superPower = UserDefaults.standard.string(forKey: "superPower") ?? ""
        
        let lat = UserDefaults.standard.double(forKey: "lat")
        
        let lon = UserDefaults.standard.double(forKey: "lon")
        
        let country = UserDefaults.standard.string(forKey: "country") ?? ""
        
        let city = UserDefaults.standard.string(forKey: "city") ?? ""
        
        let distanceUnit = UserDefaults.standard.string(forKey: "distanceUnit") ?? ""
        
        user = User(userID: userID, email: email, name: name, superheroName: superheroName, mainProfilePicUrl: self.userMainProfilePicURL, profilePicsUrls: nil, gender: Int(gender), lookingForGender: Int(favoriteGender), age: Int(age), lookingForAgeMin: ConstantRegistry.DEFAULT_MIN_AGE, lookingForAgeMax: ConstantRegistry.DEFAULT_MAX_AGE, lookingForDistanceMax: ConstantRegistry.DEFAULT_MAX_DISTANCE, distanceUnit: distanceUnit, lat: lat, lon: lon, birthday: birthday, country: country, city: city, superPower: superPower, accountType: ConstantRegistry.DEFAULT_ACCOUNT_TYPE)
        
        var params = [String: Any]()
        
        params["id"] = user!.userID
        params["email"] = user!.email
        params["name"] = user!.name
        params["superheroName"] = user!.superheroName
        params["mainProfilePicUrl"] = user!.mainProfilePicUrl
        params["gender"] = user!.gender
        params["lookingForGender"] = user!.lookingForGender
        params["age"] = user!.age
        params["lookingForAgeMin"] = user!.lookingForAgeMin
        params["lookingForAgeMax"] = user!.lookingForAgeMax
        params["lookingForDistanceMax"] = user!.lookingForDistanceMax
        params["distanceUnit"] = user!.distanceUnit
        params["lat"] = user!.lat
        params["lon"] = user!.lon
        params["birthday"] = user!.birthday
        params["country"] = user!.country
        params["city"] = user!.city
        params["superPower"] = user!.superPower
        params["accountType"] = user!.accountType
        
        return params
        
    }
    
    @objc func handleNext() {
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            var params = self.configureRegisterRequest()
            params["firebaseToken"] = result.token
            self.register(register: self.register!, params: params)
          }
        }
        
    }
    
    @objc func handlePrevious() {
        // Navigate back to SuperheroSuperPowerVC
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showIncorrectAlert() {
        
        let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            let params = self.configureRegisterRequest()
            self.register(register: self.register!, params: params)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func register(register: Register, params: [String: Any]) {
        
        register.register(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let registerResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try RegisterResponse(json: registerResponse as! [String : Any])
                
                // If registered sucessfully, save user to local db, naviagte to MainTabVC.
                // If not ok, show alert.
                if response.registered! {
                    let (err, changes) = self.userDB.updateDefaultUser(user: self.user!)
                    if case .SQLError = err {
                        print("###########  updateDefaultUser err  ##############")
                        print(err)
                    }
                    
                    print("###########  updateDefaultUser changes  ##############")
                    print(changes)
                    
                    self.navigationController?.dismiss(animated: false, completion: { () -> Void in
                        DispatchQueue.global(qos: .background).async {

                            // Background Thread

                            DispatchQueue.main.async {
                                // Run UI Updates
                                let mainTabVC = MainTabVC()
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController! = mainTabVC
                            }
                        }
                    })
                    
                } else {
                    self.showIncorrectAlert()
                }
                
            } catch {
                print("register catch")
            }
        }
        
    }
    
}
