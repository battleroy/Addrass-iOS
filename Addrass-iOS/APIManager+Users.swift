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
    
    // MARK: Session
    
    func signIn(withLogin login: String, password: String, completion: @escaping ((User?, String?) -> Void)) {
        
        let endpoint = "/j_spring_security_check"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: .post, parameters: [
            "j_username" : login,
            "j_password" : password
            ]
            )
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch (response.result) {
                case .success:
                    UserSessionManager.sharedManager.refreshSessionUser { (user, errorText) in
                        guard let sessionUser = user else {
                            completion(nil, errorText!)
                            return
                        }
                        
                        completion(sessionUser, nil)
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
        }
        
    }
    
    
    func signOut(_ completion: @escaping (() -> Void)) {
        
        let endpoint = "/j_spring_security_logout"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint).response { response in
            completion()
        }
        
    }
    
    
    func sessionUser(_ completion: @escaping ((User?, String?) -> Void)) {
        self.user(byLogin: "", completion: completion)
    }
    
    
    // MARK: CRUD
    
    func user(byLogin login: String?, completion: @escaping ((User?, String?) -> Void)) {
        
        let endpoint = "/user/\(login ?? "")"
        
        Alamofire.request(APIManager.apiRoot + endpoint).responseJSON { response in
            
            guard let JSON = response.result.value as? [String: Any] else {
                completion(nil, "Can't fetch user.")
                return
            }
            
            completion(User.user(withDictionary: JSON), nil)
        }
    }
    
    
    func createUser(_ user: User, completion: @escaping ((String?) -> Void)) {
        self.sendUser(user, method: .post, completion: completion)
    }
    
    
    func updateUser(_ newUserData: User, completion: @escaping ((String?) -> Void)) {
        self.sendUser(newUserData, method: .put, completion: completion)
    }
    
    
    // MARK: Icons
    
    func userIcon(_ user: User, completion: @escaping ((UIImage?, String?) -> Void)) {
        
        guard let imageLink = user.imageLink else {
            completion(#imageLiteral(resourceName: "user-icon-placeholder"), nil)
            return
        }
        
        let endpoint = "/icon/\(imageLink)"
        
        Alamofire.request(APIManager.apiRoot + endpoint).responseImage { response in
            
            guard let image = response.result.value else {
                completion(nil, "Can't get image")
                return
            }
            
            completion(image, nil)
        }
        
    }
    
    
    func setUserIcon(_ icon: UIImage?, completion: @escaping (String?) -> Void) {
        
        if let newIcon = icon {
            let endpoint = "/icon/edit"
            
            self.sessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(UIImagePNGRepresentation(newIcon)!, withName: "image", fileName: "icon.png", mimeType: "image/png")
            },
             to: APIManager.apiRoot.appending(endpoint),
             encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { uploadResponse in
                        switch uploadResponse.result {
                        case .success:
                            completion(nil)
                        case .failure(let uploadError):
                            completion(uploadError.localizedDescription)
                        }
                    }
                case .failure(let encodingError):
                    completion(encodingError.localizedDescription)
                }
            })
        } else {
            let endpoint = "/icon"
            
            self.sessionManager.request(APIManager.apiRoot + endpoint, method: .delete).responseString { reponseString in
                switch reponseString.result {
                case .success:
                    completion(nil)
                case .failure(let iconDeletionError):
                    completion(iconDeletionError.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: Private methods
    
    private func sendUser(_ newUserData: User, method: HTTPMethod, completion: @escaping ((String?) -> Void)) {
        let endpoint = "/user"
        
        let userDict = newUserData.dictionaryRepresentation()
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: method, parameters: userDict, encoding: JSONEncoding.default)
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
