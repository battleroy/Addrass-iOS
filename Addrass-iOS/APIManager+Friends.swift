//
//  APIManager+Contacts.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/11/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import Alamofire


extension APIManager {
    
    // MARK: Friends
    
    static func friends(forUser user: User, completion: @escaping ([User]?, String?) -> Void) {
        
        let endpoint = "/friend/all"
        
        Alamofire.request(apiRoot + endpoint).responseJSON { (response) in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch friends.")
                return
            }
            
            completion(User.userList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    static func addFriend(_ userLogin: String, completion: @escaping (String?) -> Void) {
        friendRequest(userLogin, method: .post, completion: completion)
    }
    
    
    static func deleteFriend(_ userLogin: String, completion: @escaping (String?) -> Void) {
        friendRequest(userLogin, method: .delete, completion: completion)
    }
    
    
    private static func friendRequest(_ userLogin: String, method: HTTPMethod, completion: @escaping (String?) -> Void) {
        
        let endpoint = "/friend/\(userLogin)"
        
        Alamofire.request(apiRoot + endpoint, method: method)
            .validate(statusCode: 200..<300)
            .responseString { responseString in
            switch responseString.result {
            case .success:
                completion(nil)
            case .failure(let deleteError):
                if let responseStatusCode = responseString.response?.statusCode {
                    switch responseStatusCode {
                    case 404:
                        completion(String.ad.userDoesntExist)
                        return
                    default:
                        break
                    }
                }
                
                completion(deleteError.localizedDescription)
            }
        }
    }

    
}
