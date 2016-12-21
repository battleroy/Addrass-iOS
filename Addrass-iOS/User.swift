//
//  User.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class User: NSObject {

    var login:    String?
    var password: String?
    var name:     String?
    var group:    String?
    var image:    String?
    var color:    String?
    var phone:    String?
    var email:    String?
    var company:  String?
    var address:  String?
    var notes:    String?
    var friends:  [User]?
    var blacklist: [User]?
    
    convenience override init() {
        self.init(withName: nil, group: nil, image: nil, color: nil, phone: nil, email: nil, company: nil, address: nil, notes: nil)
    }
    
    
    init(withName name: String?, group: String?, image: String?, color: String?, phone: String?, email: String?, company: String?, address: String?, notes: String?) {
        super.init()
        
        self.name = name
        self.group = group
        self.image = image
        self.color = color
        self.phone = phone
        self.email = email
        self.company = company
        self.address = address
        self.notes = notes
    }
    
    
    func dictionaryRepresentation() -> [String : Any] {
        
        var result = Dictionary<String, Any>()
        
        result["userLogin"] = login ?? NSNull()
        result["userPassword"] = password ?? NSNull()
        result["userName"] = name ?? NSNull()
        result["groupName"] = group ?? NSNull()
        result["fkUserPhoto"] = image ?? NSNull()
        result["userColor"] = color ?? NSNull()
        result["userPhoneField"] = phone ?? NSNull()
        result["userEmailField"] = email ?? NSNull()
        result["userOrganizationField"] = company ?? NSNull()
        result["userAddressField"] = address ?? NSNull()
        result["userNotesField"] = notes ?? NSNull()
        
        return result
    }
    
    
    static func user(withDictionary dict: [String : Any]) -> User {
        let user = User()
        
        user.name = dict["userLogin"] as? String
        user.password = dict["userPassword"] as? String
        user.group = dict["groupName"] as? String
        user.image = dict["fkUserPhoto"] as? String
        user.color = dict["userColor"] as? String
        user.phone = dict["userPhoneField"] as? String
        user.email = dict["userEmailField"] as? String
        user.company = dict["userOrganizationField"] as? String
        user.address = dict["userAddressField"] as? String
        user.notes = dict["userNotesField"] as? String
    
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
