//
//  EditProfileInfoVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class EditProfileInfoVC: UIViewController, UITextViewDelegate {
    
    let userDB = UserDB.sharedDB
    var user: User?
    
    var update: Update?
    
    var kmMiSV: UIStackView!
    
    let superPowerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your Super Power?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let superPowerTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tv.font = UIFont.systemFont(ofSize: 18)
        
        return tv
    }()
    
    let superheroDistanceUnitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Kilometers / Miles"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let kmBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kilometers", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectKm), for: .touchUpInside)
        
        return btn
    }()
    
    let miBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Miles", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectMi), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        superPowerTextView.delegate = self
        
        configureSuperPower()
        
        configureKmMi()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        if user != nil {
            self.user = user
            
            superPowerTextView.text = self.user?.superPower
            
            configureDistanceUnitButtons()
        }
        
        update = Update()
    }
    
    func configureDistanceUnitButtons() {
        
        // configure distance unit buttons here
        switch self.user?.distanceUnit {
        case ConstantRegistry.KILOMETERS:
            // Configure buttons
            kmBtn.setTitleColor(.white, for: .normal)
            kmBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            miBtn.setTitleColor(.black, for: .normal)
            miBtn.backgroundColor = .white
            
            break
        case ConstantRegistry.MILES:
            // Configure buttons
            kmBtn.setTitleColor(.black, for: .normal)
            kmBtn.backgroundColor = .white
            
            miBtn.setTitleColor(.white, for: .normal)
            miBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            break
        default:
            
            
            break
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard !superPowerTextView.hasText else {
            
            let (spErr, _) = self.userDB.updateUserSuperPower(superPower: superPowerTextView.text!, userId: self.user?.userID)
            if case .SQLError = spErr {
                print("###########  updateUserSuperPower spErr  ##############")
                print(spErr)
            }
            
            return
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let maxLength = 125
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= maxLength
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureSuperPower() {
        
        view.addSubview(superPowerLabel)
        superPowerLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 50)
        
        view.addSubview(superPowerTextView)
        superPowerTextView.anchor(top: superPowerLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 260, height: 120)
        
    }
    
    func configureKmMi() {
        
        view.addSubview(superheroDistanceUnitLabel)
        superheroDistanceUnitLabel.anchor(top: superPowerTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        kmMiSV = UIStackView(arrangedSubviews: [kmBtn, miBtn])
        kmMiSV.axis = .horizontal
        kmMiSV.spacing = 10
        kmMiSV.distribution = .fillEqually
        
        view.addSubview(kmMiSV)
        kmMiSV.anchor(top: superheroDistanceUnitLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 260, height: 80)
        kmMiSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func handleSelectKm() {
        
        // Configure buttons
        kmBtn.setTitleColor(.white, for: .normal)
        kmBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        miBtn.setTitleColor(.black, for: .normal)
        miBtn.backgroundColor = .white
        
        let (duErr, _) = self.userDB.updateUserDistanceUnit(distanceUnit: ConstantRegistry.KILOMETERS, userId: self.user?.userID)
        if case .SQLError = duErr {
            print("###########  updateUserDistanceUnit duErr  ##############")
            print(duErr)
        }
        
    }
    
    @objc func handleSelectMi() {
        
        // Configure buttons
        kmBtn.setTitleColor(.black, for: .normal)
        kmBtn.backgroundColor = .white
        
        miBtn.setTitleColor(.white, for: .normal)
        miBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        let (duErr, _) = self.userDB.updateUserDistanceUnit(distanceUnit: ConstantRegistry.MILES, userId: self.user?.userID)
        if case .SQLError = duErr {
            print("###########  updateUserDistanceUnit duErr  ##############")
            print(duErr)
        }
        
    }
    
    func configureUpdateProfileRequest() -> [String: Any]? {
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        if user != nil {
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
        
       
        return nil
    }
    
    func update(update: Update, params: [String: Any]) {
        
        update.update(params: params) { json, error in
            do {
                
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: json!, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
                let updateResponse = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                
                let response = try UpdateProfileResponse(json: updateResponse as! [String : Any])

                if !response.updated {
                    print("Something went wrong!")
                } else {
                    print("All good!")
                }
                
            } catch {
                print("update catch")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // update(update: self.update!, params: self.configureUpdateProfileRequest()!)
    }
    
    // override func view
    
}
