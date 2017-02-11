//
//  APIManager+Users.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/11/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


extension APIManager {
    
    // MARK: Users
    
    static func signIn(withLogin login: String, password: String, completion: @escaping ((User?, String?) -> Void)) {
        
        let endpoint = "/j_spring_security_check"
        
        Alamofire.request(apiRoot + endpoint, method: .post, parameters: [
            "j_username" : login,
            "j_password" : password
            ]
            )
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                switch (response.result) {
                case .success:
                    user(byLogin: login, completion: { (user, errorText) in
                        SessionManager.currentUser = user
                        completion(user, errorText)
                    })
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
        }
        
    }
    
    
    static func signOut(_ completion: @escaping (() -> Void)) {
        
        let endpoint = "/j_spring_security_logout"
        
        Alamofire.request(apiRoot + endpoint).response { (response) in
            completion()
        }
        
    }
    
    
    static func user(byLogin login: String?, completion: @escaping ((User?, String?) -> Void)) {
        
        let endpoint = "/user/\(login ?? "")"
        
        Alamofire.request(apiRoot + endpoint).responseJSON { response in
            
            guard let JSON = response.result.value as? [String: Any] else {
                completion(nil, "Can't fetch user.")
                return
            }
            
            completion(User.user(withDictionary: JSON), nil)
        }
    }
    
    
    static func createUser(_ user: User, completion: @escaping ((String?) -> Void)) {
        sendUser(user, method: .post, completion: completion)
    }
    
    
    static func updateUser(_ newUserData: User, completion: @escaping ((String?) -> Void)) {
        sendUser(newUserData, method: .put, completion: completion)
    }

    
    static func userIcon(_ user: User, completion: @escaping ((UIImage?, String?) -> Void)) {
        
        guard let imageLink = user.image else {
            completion(#imageLiteral(resourceName: "user-icon-placeholder"), nil)
            return
        }
        
        let endpoint = "/icon/\(imageLink)"
        
        Alamofire.request(apiRoot + endpoint).responseImage { response in
            
            guard let image = response.result.value else {
                completion(nil, "Can't get image")
                return
            }
            
            completion(image, nil)
        }
        
    }
    
    
    // MARK: Private methods
    
    private static func sendUser(_ newUserData: User, method: HTTPMethod, completion: @escaping ((String?) -> Void)) {
        let endpoint = "/user"
        
        let userDict = newUserData.dictionaryRepresentation()
        
        Alamofire.request(apiRoot + endpoint, method: method, parameters: userDict, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch (response.result) {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error.localizedDescription)
                }
        }
    }
    
}
