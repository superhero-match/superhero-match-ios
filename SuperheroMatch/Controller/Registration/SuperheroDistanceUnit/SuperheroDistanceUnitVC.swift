//
//  SuperheroDistanceUnitVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 06/10/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SuperheroDistanceUnitVC: UIViewController {
    
    var kmMiSV: UIStackView!
    var nextPreviousSV: UIStackView!
    
    let superheroDistanceUnitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Distance Unit"
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
    
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
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
        
        view.addSubview(superheroDistanceUnitLabel)
        superheroDistanceUnitLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        configureKmMi()
        
        configureNextPrevious()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    func configureKmMi() {
        
        kmMiSV = UIStackView(arrangedSubviews: [kmBtn, miBtn])
        kmMiSV.axis = .horizontal
        kmMiSV.spacing = 10
        kmMiSV.distribution = .fillEqually
        
        view.addSubview(kmMiSV)
        kmMiSV.anchor(top: superheroDistanceUnitLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 260, height: 80)
        kmMiSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureNextPrevious() {
        
        nextPreviousSV = UIStackView(arrangedSubviews: [nextBtn, previousBtn])
        nextPreviousSV.axis = .vertical
        nextPreviousSV.spacing = 20
        nextPreviousSV.distribution = .fillEqually
        
        view.addSubview(nextPreviousSV)
        nextPreviousSV.anchor(top: kmMiSV.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 100)
    }
    
    @objc func handleNext() {
        
        // Navigate to SuperheroGenderVC
        let superheroGenderVC = SuperheroGenderVC()
        navigationController?.pushViewController(superheroGenderVC, animated: true)
        
    }
    
    @objc func handlePrevious() {
        
        // Navigate back to SuperheroNameVC
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handleSelectKm() {
        
        // Configure buttons
        kmBtn.setTitleColor(.white, for: .normal)
        kmBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        miBtn.setTitleColor(.black, for: .normal)
        miBtn.backgroundColor = .white
        
        // Enable next button
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        UserDefaults.standard.set("km", forKey: "distanceUnit")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func handleSelectMi() {
        
        // Configure buttons
        kmBtn.setTitleColor(.black, for: .normal)
        kmBtn.backgroundColor = .white
        
        miBtn.setTitleColor(.white, for: .normal)
        miBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        // Enable next button
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        UserDefaults.standard.set("mi", forKey: "distanceUnit")
        UserDefaults.standard.synchronize()
        
    }
    
    
}
