//
//  SuperheroBirthdayVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 17/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit

class SuperheroBirthdayVC: UIViewController {
    
    let superheroBirthdayLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your birthday?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let birthdayPicker: UIDatePicker = {
        let dp = UIDatePicker()
        
        // Set some of UIDatePicker properties
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = UIColor.white
        dp.datePickerMode = .date
        
        // Add an event to call onDidChangeDate function when value is changed.
        dp.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return dp
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
        
        configureComponents()
        
        view.addSubview(termsAndPoliciesBtn)
        termsAndPoliciesBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func configureComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [superheroBirthdayLabel, birthdayPicker, nextBtn, previousBtn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
    }
    
    @objc func handleNext() {
        
        // Navigate to SuperheroDistanceUnitVC
        let superheroDistanceUnitVC = SuperheroDistanceUnitVC()
        navigationController?.pushViewController(superheroDistanceUnitVC, animated: true)
        
    }
    
    @objc func handlePrevious() {
        
        // Navigate back to SuperheroNameVC
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @objc func datePickerValueChanged(){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: birthdayPicker.date)
        
        // Check if the age is at least 18 years old
        // if so, enable button, and change button color
        // if not, show pop-up with message that user must be at least 18 years old
        let interval = Date().calculateDifference(recent: Date(), previous: birthdayPicker.date)
        guard interval.year! >= 18 else {
            
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            showIncorrectAgeAlert()
            
            return
            
        }
        
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
        UserDefaults.standard.set(interval.year!, forKey: "age")
        UserDefaults.standard.set(selectedDate, forKey: "birthday")
        UserDefaults.standard.synchronize()
        
        print("Selected value \(selectedDate)")
    }
    
    func showIncorrectAgeAlert() {
        let alert = UIAlertController(title: "You must be 18+", message: "You can only use this app if you are 18 years old or older", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
