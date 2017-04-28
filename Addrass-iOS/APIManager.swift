//
//  APIManager.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class APIManager {
    
    // MARK: Properties
    
    static var sharedManager: APIManager = {
        let manager = APIManager()
        return manager
    }()
    
    
    var sessionManager: Alamofire.SessionManager = {
        let mainServerTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: ServerTrustPolicy.certificates(),
            validateCertificateChain: true,
            validateHost: true
        )
        
        let manager = Alamofire.SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: [
                "localhost" : mainServerTrustPolicy
            ])
        )
        return manager
    }()
    
    
    // MARK: Constants
    
    static let apiRoot: String = "https://localhost:8443/addrass"
    static let chatEndpoint: URL = URL(string: "wss://localhost:8443/addrass/ws/websocket")!
    
}
