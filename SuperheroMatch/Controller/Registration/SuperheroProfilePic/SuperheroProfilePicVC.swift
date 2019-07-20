//
//  SuperheroProfilePicVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 17/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SuperheroProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageIsSelected: Bool!
    var register: Register?
    
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
        
        view.addSubview(superheroProfilePicLabel)
        superheroProfilePicLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(selectPicBtn)
        selectPicBtn.anchor(top: superheroProfilePicLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 175, height: 175)
        selectPicBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureComponents()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        register = Register()
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
        
        // TO-DO: convert image to bytes array or base64 encoded string and send it to the server
        // there it is going ot be uploaded to S3, and from there the CloudFront will cache it
        
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
        
        let userID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let user = User(userID: userID, email: email, name: name, superheroName: superheroName, mainProfilePicUrl: "", profilePicsUrls: nil, gender: Int64(gender), lookingForGender: Int64(favoriteGender), age: Int64(age), lookingForAgeMin: 25, lookingForAgeMax: 55, lookingForDistanceMax: 50, distanceUnit: "km", lat: 0.0, lon: 0.0, birthday: birthday, country: "Country", city: "City", superPower: superPower, accountType: "FREE")
        
        var params = [String: Any]()
        
        params["id"] = user.userID
        params["email"] = user.email
        params["name"] = user.name
        params["superheroName"] = user.superheroName
        params["mainProfilePicUrl"] = user.mainProfilePicUrl
        params["gender"] = user.gender
        params["lookingForGender"] = user.lookingForGender
        params["age"] = user.age
        params["lookingForAgeMin"] = user.lookingForAgeMin
        params["lookingForAgeMax"] = user.lookingForAgeMax
        params["lookingForDistanceMax"] = user.lookingForDistanceMax
        params["distanceUnit"] = user.distanceUnit
        params["lat"] = user.lat
        params["lon"] = user.lon
        params["birthday"] = user.birthday
        params["country"] = user.country
        params["city"] = user.city
        params["superPower"] = user.superPower
        params["accountType"] = user.accountType
        
        return params
        
    }
    
    @objc func handleNext() {
        let params = configureRegisterRequest()
        register(register: register!, params: params)
    }
    
    @objc func handlePrevious() {
        // Navigate back to SuperheroFavoriteGenderVC
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showIncorrectAgeAlert() {
        
        let alert = UIAlertController(title: "Something went wrong", message: "Something went wrong. Please try agin later.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            // Retry Action
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
                
                print(response.status!)
                print(response.registered!)
                
                if response.registered! {
                    // TO-DO: save to local db
                    
                    let mainTabVC = MainTabVC()
                    self.present(mainTabVC, animated: true, completion: nil)
                } else {
                    self.showIncorrectAgeAlert()
                }
                
            } catch {
                print("catch")
            }
        }
        
    }

}
