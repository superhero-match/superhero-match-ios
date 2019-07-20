//
//  NetworkManager.swift
//  SuperheroMatch
//
//  Created by Nikolajus Karpovas on 20/07/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

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

