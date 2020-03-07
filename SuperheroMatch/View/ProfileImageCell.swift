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

class ProfileImageCell: UICollectionViewCell {
    
    var imageUrl: String? {
          didSet {
              // image: UIImage(named: "test10")
              profileImageView.image = UIImage(named: imageUrl!)
          }
      }
      
      var nameAndAge: String? {
          didSet {
              // userNameAge.text = "Superhero, 34"
              userNameAge.text = nameAndAge
          }
      }
      
      var location: String? {
          didSet {
              // city.text = "Somewhere"
              city.text = location
          }
      }
      
      var superpower : String? {
          didSet {
              superPower.text = superpower
              // superPower.text = "Awesome Super Power that I have and it is just test to see how it looks like on the screen when character length is maxed out."
          }
      }
      
      let profileImageView: UIImageView = {
          let piv = UIImageView()
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
      
      let gradientView: UIView = {
          let view = UIView()
          
          return view
      }()
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          
          addSubview(profileImageView)
          profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.height)
          profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
          
          addSubview(gradientView)
          gradientView.anchor(top: nil, left: nil, bottom: profileImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 125)
          gradientView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
          
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1).cgColor]
          gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
          gradientLayer.locations = [0, 1]
          gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width-10, height: 115)
          
          gradientView.layer.insertSublayer(gradientLayer, at: 0)
          
          addSubview(superPower)
          superPower.anchor(top: nil, left: leftAnchor, bottom: profileImageView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: frame.width, height: 60)
          
          addSubview(city)
          city.anchor(top: nil, left: leftAnchor, bottom: superPower.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 25)
          
          addSubview(userNameAge)
          userNameAge.anchor(top: nil, left: leftAnchor, bottom: city.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
          
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
    
}
