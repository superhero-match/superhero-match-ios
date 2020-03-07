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

import Foundation
import Alamofire

class NetworkManager: NSObject, URLSessionDelegate {
    
    var customSessionDelegate = CustomSessionDelegate()
    var manager: SessionManager?
    
    override init() {
        super.init()
        configureManager()
    }
    
    func configureManager() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        configuration.timeoutIntervalForResource = 40
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "mwsoft.nl": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            )
        ]
        
        self.manager = SessionManager(
            configuration: configuration,
            delegate: customSessionDelegate,
            serverTrustPolicyManager: CustomServerTrustPolicyManager(
                policies: serverTrustPolicies
            )
        )
    }
    
    func loadUrl(url: String, params: [String: Any]?, method: HTTPMethod, encoding: URLEncoding?, closure: @escaping (_ json: Any?, _ error: Error?)->()) {
        let urlObj = URL(string: url)
        
        // TO-DO: once authorization is implemeted, add authorization header --> "Authorization": "Bearer \(accessToken)"
        // Specify the Headers
        self.manager?.session.configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "X-Platform": "iOS",
            "User-Agent": "SuperheroMatch"
        ]
        
        self.manager?.request(
            urlObj!,
            method: method,
            parameters: params != nil ? params : nil,
            encoding: encoding != nil ? encoding! : JSONEncoding.default,
            headers: SessionManager.defaultHTTPHeaders
        ).responseJSON(
            queue: nil,
            options: JSONSerialization.ReadingOptions.allowFragments
        ) { (response) in
            
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    closure(nil, error)
                }
                
            case .success(let data):
                DispatchQueue.main.async {
                    closure(data, nil)
                }
            }
    
        }.session.finishTasksAndInvalidate() 
    }
    
}

