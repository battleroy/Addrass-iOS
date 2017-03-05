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
    
    // MARK: Constants
    
    static let apiRoot: String = "http://localhost:8080" // "https://addrass.herokuapp.com";
    static let chatEndpoint: URL = URL(string: "ws://localhost:8080/ws/websocket")!
    
}
