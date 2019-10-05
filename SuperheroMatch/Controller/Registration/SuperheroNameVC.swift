//
//  SuperheroNameVC.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 17/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import UIKit
import CoreLocation

class SuperheroNameVC: UIViewController, CLLocationManagerDelegate {
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    var timer = Timer()
    
    var latitude: Double?
    
    var longitude: Double?
    
    let superheroNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What is your Superhero name?"
        lbl.font = UIFont(name: "Gotham Book", size: 22)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        
        return lbl
    }()
    
    let superheroNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Your Superhero Name..."
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleValueChanged), for: .editingChanged)
        
        return tf
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
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "lon")
            UserDefaults.standard.synchronize()
            
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
    
    func configureComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [superheroNameLabel, superheroNameTextField, nextBtn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
    }
    
    @objc func handleNext() {
        print("handleNext has been called")
        UserDefaults.standard.set(superheroNameTextField.text!, forKey: "superheroName")
        UserDefaults.standard.synchronize()
        
        // For now just navigate to SuperheroNameVC
        let superheroBirthdayVC = SuperheroBirthdayVC()
        navigationController?.pushViewController(superheroBirthdayVC, animated: true)
    }
    
    @objc func handleValueChanged() {
        
        guard superheroNameTextField.hasText else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            
            return
        }
        
        guard superheroNameTextField.text!.count >= 2 else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            
            return
        }
        
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        
    }
    
}
