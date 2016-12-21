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


class APIManager: NSObject {
    
    // MARK: Constants
    
    static let apiRoot = "https://addrass.herokuapp.com";
    
    
    // MARK: Users
    
    static func register(_ user: User, completion: @escaping ((String?) -> Void)) {
        
        let endpoint = "/user"
        let dictionaryRepresentation = user.dictionaryRepresentation()
        
        Alamofire.request(apiRoot + endpoint, method: .post, parameters: dictionaryRepresentation, encoding: JSONEncoding.default)
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
        
        let endpoint = "/user/search/\(login ?? "")"
        
        Alamofire.request(apiRoot + endpoint).responseJSON { response in
            
            guard let JSON = response.result.value as? [String: Any] else {
                completion(nil, "Can't fetch user.")
                return
            }
            
            completion(User.user(withDictionary: JSON), nil)
        }
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
    
    
    // MARK: Contacts
    
    static func contacts(forUser user: User, completion: @escaping ([User]?, String?) -> Void) {
        
        let endpoint = "/contact/all"
    
        Alamofire.request(apiRoot + endpoint).responseJSON { (response) in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch contacts.")
                return
            }
            
            completion(User.userList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    static func update(_ userLogin: String, newUserData: User) -> Bool {
        fatalError()
    }
    
    
    static func delete(_ userLogin: String, user: User) -> Bool {
        fatalError()
    }
    
    
    // MARK: Events
    
    static func create(_ event: Event, forOwner: User) -> Bool {
        fatalError()
    }
    
    
    static func events(forUser user: User) -> [Event] {
        fatalError()
    }
    
    
    static func update(_ userLogin: String, newEventData: Event) -> Bool {
        fatalError()
    }
    
    
    static func delete(_ userLogin: String, event: Event) -> Bool {
        fatalError()
    }
    
}
