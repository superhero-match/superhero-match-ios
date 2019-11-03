//
//  ProfileSettingsVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 19/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import RangeSeekSlider

class ProfileSettingsVC: UIViewController {
    
    let userDB = UserDB.sharedDB
    var user: User?
    
    var update: Update?
    
    var genderSV: UIStackView!
    
    let superheroFavoriteGenderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your favorite gender?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let maleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Male", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectMale), for: .touchUpInside)
        
        return btn
    }()
    
    let femaleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Female", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectFemale), for: .touchUpInside)
        
        return btn
    }()
    
    let bothBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Both", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleSelectBoth), for: .touchUpInside)
        
        return btn
    }()
    
    let superheroAgeRangeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Age"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    let ageRangeSlider: RangeSeekSlider = {
        let rs = RangeSeekSlider()
        rs.minValue = 18
        rs.maxValue = 100
        rs.tintColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        rs.colorBetweenHandles = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        rs.minLabelFont = UIFont(name: "Gotham Book", size: 20)!
        rs.maxLabelFont = UIFont(name: "Gotham Book", size: 20)!
        rs.labelsFixed = true
        rs.lineHeight = 5
        rs.enableStep = true
        rs.step = 1
        rs.addTarget(self, action: #selector(handleSelectAgeRange), for: .touchUpInside)
        
        return rs
    }()
    
    let superheroDistanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Distance"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    let distanceSlider: RangeSeekSlider = {
        let rs = RangeSeekSlider()
        rs.maxValue = 100
        rs.tintColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        rs.colorBetweenHandles = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        rs.maxLabelFont = UIFont(name: "Gotham Book", size: 20)!
        rs.labelsFixed = true
        rs.lineHeight = 5
        rs.enableStep = true
        rs.step = 1
        rs.disableRange = true
        rs.addTarget(self, action: #selector(handleSelectDistance), for: .touchUpInside)
        
        return rs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color white
        view.backgroundColor = .white
        
        configureFavoriteGender()
        configureAgeRange()
        configureDistance()
        
        let (dbErr, user) = self.userDB.getUser()
        if case .SQLError = dbErr {
            print("###########  getUser dbErr  ##############")
            print(dbErr)
        }
        
        if user != nil {
            self.user = user
            
            configureGenderButtons()
            configureAgeRangeCurrentValues()
            configureMaxDistanceValue()
            
        }
        
        update = Update()
        
    }
    
    func configureGenderButtons() {
        
        switch self.user?.lookingForGender {
        case ConstantRegistry.MALE:
            maleBtn.setTitleColor(.white, for: .normal)
            maleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            femaleBtn.setTitleColor(.black, for: .normal)
            femaleBtn.backgroundColor = .white
            
            bothBtn.setTitleColor(.black, for: .normal)
            bothBtn.backgroundColor = .white
            
            break
        case ConstantRegistry.FEMALE:
            maleBtn.setTitleColor(.black, for: .normal)
            maleBtn.backgroundColor = .white
            
            femaleBtn.setTitleColor(.white, for: .normal)
            femaleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            bothBtn.setTitleColor(.black, for: .normal)
            bothBtn.backgroundColor = .white
            
            break
        case ConstantRegistry.BOTH:
            maleBtn.setTitleColor(.black, for: .normal)
            maleBtn.backgroundColor = .white
            
            femaleBtn.setTitleColor(.black, for: .normal)
            femaleBtn.backgroundColor = .white
            
            bothBtn.setTitleColor(.white, for: .normal)
            bothBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
            break
        default:
            
            break
        }
        
    }
    
    func configureAgeRangeCurrentValues() {
        
        ageRangeSlider.selectedMinValue = CGFloat(Float((self.user?.lookingForAgeMin!)!))
        ageRangeSlider.selectedMaxValue = CGFloat(Float((self.user?.lookingForAgeMax!)!))
        
    }
    
    func configureMaxDistanceValue() {
        
        distanceSlider.selectedMaxValue = CGFloat(Float((self.user?.lookingForDistanceMax!)!))
        
    }
    
    func configureFavoriteGender() {
        
        view.addSubview(superheroFavoriteGenderLabel)
        superheroFavoriteGenderLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        genderSV = UIStackView(arrangedSubviews: [maleBtn, bothBtn, femaleBtn])
        genderSV.axis = .horizontal
        genderSV.spacing = 10
        genderSV.distribution = .fillEqually
        
        view.addSubview(genderSV)
        genderSV.anchor(top: superheroFavoriteGenderLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 300, height: 90)
        genderSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func handleSelectMale() {
        
        // Configure buttons
        maleBtn.setTitleColor(.white, for: .normal)
        maleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        femaleBtn.setTitleColor(.black, for: .normal)
        femaleBtn.backgroundColor = .white
        
        bothBtn.setTitleColor(.black, for: .normal)
        bothBtn.backgroundColor = .white
        
        let (spErr, _) = self.userDB.updateUserLookingForGender(lookingForGender: ConstantRegistry.MALE, userId: self.user?.userID)
        if case .SQLError = spErr {
            print("###########  updateUserSuperPower spErr  ##############")
            print(spErr)
        }
        
    }
    
    @objc func handleSelectFemale() {
        
        // Configure buttons
        maleBtn.setTitleColor(.black, for: .normal)
        maleBtn.backgroundColor = .white
        
        femaleBtn.setTitleColor(.white, for: .normal)
        femaleBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        bothBtn.setTitleColor(.black, for: .normal)
        bothBtn.backgroundColor = .white
        
        let (spErr, _) = self.userDB.updateUserLookingForGender(lookingForGender: ConstantRegistry.FEMALE, userId: self.user?.userID)
        if case .SQLError = spErr {
            print("###########  updateUserSuperPower spErr  ##############")
            print(spErr)
        }
        
    }
    
    @objc func handleSelectBoth() {
        
        // Configure buttons
        maleBtn.setTitleColor(.black, for: .normal)
        maleBtn.backgroundColor = .white
        
        femaleBtn.setTitleColor(.black, for: .normal)
        femaleBtn.backgroundColor = .white
        
        bothBtn.setTitleColor(.white, for: .normal)
        bothBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        let (spErr, _) = self.userDB.updateUserLookingForGender(lookingForGender: ConstantRegistry.BOTH, userId: self.user?.userID)
        if case .SQLError = spErr {
            print("###########  updateUserSuperPower spErr  ##############")
            print(spErr)
        }
        
    }
    
    func configureAgeRange() {
        
        view.addSubview(superheroAgeRangeLabel)
        superheroAgeRangeLabel.anchor(top: genderSV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(ageRangeSlider)
        ageRangeSlider.anchor(top: superheroAgeRangeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 50)
        
    }
    
    @objc func handleSelectAgeRange() {
        
        let (spErr, _) = self.userDB.updateUserLookingForMinMaxAge(minAge: Int(ageRangeSlider.selectedMinValue), maxAge: Int(ageRangeSlider.selectedMaxValue), userId: self.user?.userID)
        if case .SQLError = spErr {
            print("###########  updateUserLookingForMinMaxAge spErr  ##############")
            print(spErr)
        }
        
    }
    
    func configureDistance() {
        
        view.addSubview(superheroDistanceLabel)
        superheroDistanceLabel.anchor(top: ageRangeSlider.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(distanceSlider)
        distanceSlider.anchor(top: superheroDistanceLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 50)
        
    }
    
    @objc func handleSelectDistance() {
        
        let (spErr, _) = self.userDB.updateUserLookingForMaxDistance(lookingForMaxDistance: Int(distanceSlider.selectedMaxValue), userId: self.user?.userID)
        if case .SQLError = spErr {
            print("###########  updateUserLookingForMaxDistance spErr  ##############")
            print(spErr)
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
        update(update: self.update!, params: self.configureUpdateProfileRequest()!)
    }
    
}
