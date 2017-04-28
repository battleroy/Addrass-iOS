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
    
    func friends(_ completion: @escaping ([User]?, String?) -> Void) {
        
        let endpoint = "/friend/all"
        
        Alamofire.request(APIManager.apiRoot + endpoint).responseJSON { (response) in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch friends.")
                return
            }
            
            completion(User.userList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    func addFriend(_ userLogin: String, completion: @escaping (String?) -> Void) {
        self.friendRequest(userLogin, method: .post, completion: completion)
    }
    
    
    func deleteFriend(_ userLogin: String, completion: @escaping (String?) -> Void) {
        self.friendRequest(userLogin, method: .delete, completion: completion)
    }
    
    
    private func friendRequest(_ userLogin: String, method: HTTPMethod, completion: @escaping (String?) -> Void) {
        
        let endpoint = "/friend/\(userLogin)"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: method)
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
