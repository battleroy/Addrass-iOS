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
    
    static func update(_ userLogin: String, newUserData: User) -> Bool {
        fatalError()
    }
    
    
    static func delete(_ userLogin: String, user: User) -> Bool {
        fatalError()
    }

    
}
