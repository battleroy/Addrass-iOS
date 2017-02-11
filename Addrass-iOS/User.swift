//
//  User.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

struct User {

    var id:         Int?
    var login:      String?
    var password:   String?
    var firstName:  String?
    var lastName:   String?
    var image:      String?
    var phone:      String?
    var email:      String?
    var address:    String?
    
    var fullName: String {
        get {
            var result = lastName ?? ""
            if let firstName = firstName {
                result = firstName + " " + result
            }
            return result
        }
    }
    
    init() {
        self.init(withId: nil, firstName: nil, lastName: nil, image: nil, phone: nil, email: nil, address: nil)
    }
    
    
    init(withId id: Int?, firstName: String?, lastName: String?, image: String?, phone: String?, email: String?, address: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.image = image
        self.phone = phone
        self.email = email
        self.address = address
    }
    
    
    func dictionaryRepresentation() -> [String : Any] {
        
        var result = Dictionary<String, Any>()
        
        result["id"] = id ?? NSNull()
        result["userLogin"] = login ?? NSNull()
        result["userPassword"] = password ?? NSNull()
        result["userFirstName"] = firstName ?? NSNull()
        result["userLastName"] = lastName ?? NSNull()
        result["userPhone"] = phone ?? NSNull()
        result["userEmail"] = email ?? NSNull()
        result["userAddress"] = address ?? NSNull()
        result["userIcon"] = image ?? NSNull()
        
        return result
    }
    
    
    static func user(withDictionary dict: [String : Any]) -> User {
        var user = User()
        
        user.id = dict["pkId"] as? Int
        user.login = dict["userLogin"] as? String
        user.password = dict["userPassword"] as? String
        user.firstName = dict["userFirstName"] as? String
        user.lastName = dict["userLastName"] as? String
        user.phone = dict["userPhone"] as? String
        user.email = dict["userEmail"] as? String
        user.address = dict["userAddress"] as? String
        user.image = dict["userIcon"] as? String
    
        return user
    }
    
    
    static func userList(withDictionaryList dictList: [[String: Any]]) -> [User]? {
        
        var result = [User]()
        
        for contactDict in dictList {
            if let userDict = contactDict["fkUserFriend"] {
                result.append(User.user(withDictionary: userDict as! [String: Any]))
            }
        }
        
        return result
    }
}
