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
import UIKit
import Alamofire

class CustomSessionDelegate: SessionDelegate {
    
    // Note that this is the almost the same implementation as in the ViewController.swift
    override init() {
        super.init()
        
        // Alamofire uses a block var here
        sessionDidReceiveChallengeWithCompletion = { session, challenge, completion in
            guard let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 else {
                // This case will probably get handled by ATS, but still...
                completion(.cancelAuthenticationChallenge, nil)
                return
            }
            
            // Compare the server certificate with our own stored
            if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
                
                if CustomSessionDelegate.pinnedCertificates().contains(serverCertificateData) {
                    completion(.useCredential, URLCredential(trust: trust))
                    return
                }
            }
            
            // Or, compare the public keys
            if let serverCertificate = SecTrustGetCertificateAtIndex(trust, 0), let serverCertificateKey = CustomSessionDelegate.publicKey(for: serverCertificate) {
                if CustomSessionDelegate.pinnedKeys().contains(serverCertificateKey) {
                    completion(.useCredential, URLCredential(trust: trust))
                    return
                }
            }
            
            completion(.cancelAuthenticationChallenge, nil)
        }
    }
    
    private static func pinnedCertificates() -> [Data] {
        var certificates: [Data] = []
        
        if let pinnedCertificateURL = Bundle.main.url(forResource: "certificate", withExtension: "der") {
            do {
                let pinnedCertificateData = try Data(contentsOf: pinnedCertificateURL)
                certificates.append(pinnedCertificateData)
            } catch (_) {
                // Handle error
            }
        }
        
        return certificates
    }
    
    private static func pinnedKeys() -> [SecKey] {
        var publicKeys: [SecKey] = []
        
        if let pinnedCertificateURL = Bundle.main.url(forResource: "certificate", withExtension: "der") {
            do {
                let pinnedCertificateData = try Data(contentsOf: pinnedCertificateURL) as CFData
                if let pinnedCertificate = SecCertificateCreateWithData(nil, pinnedCertificateData), let key = publicKey(for: pinnedCertificate) {
                    publicKeys.append(key)
                }
            } catch (_) {
                // Handle error
            }
        }
        
        return publicKeys
    }
    
    // Implementation from Alamofire
    private static func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?
        
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)
        
        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }
        
        return publicKey
    }
    
}
