//
//  User+Factoring.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/20/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

extension User {
    
    static func user(withDictionary dict: [String : Any]) -> User {
        let user = User()
        
        user.id = dict["id"] as? Int
        user.login = dict["userLogin"] as? String
        user.password = dict["userPassword"] as? String
        user.firstName = dict["userFirstName"] as? String
        user.lastName = dict["userLastName"] as? String
        user.phone = dict["userPhone"] as? String
        user.email = dict["userEmail"] as? String
        user.address = dict["userAddress"] as? String
        
        if let imageDict = dict["userIcon"] as? Dictionary<String, Any>, let imageFileName = imageDict["imageName"] as? String {
            user.imageName = imageFileName
        }
        
        return user
    }
    
    
    static func userList(withDictionaryList dictList: [[String: Any]]) -> [User]? {
        
        var result = [User]()
        
        for userDict in dictList {
            result.append(User.user(withDictionary: userDict))
        }
        
        return result
    }
    
}
