//
//  User.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class User {

    var id:         Int?
    var login:      String?
    var password:   String?
    var firstName:  String?
    var lastName:   String?
    var imageName:  String?
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
    
    var imageLink: String? {
        get {
            guard let existingImageName = imageName else {
                return nil
            }
            
            return APIManager.apiRoot + "/image/" + existingImageName
        }
    }
    
    convenience init() {
        self.init(withId: nil, firstName: nil, lastName: nil, imageName: nil, phone: nil, email: nil, address: nil)
    }
    
    
    init(withId id: Int?, firstName: String?, lastName: String?, imageName: String?, phone: String?, email: String?, address: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.imageName = imageName
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
        
        var iconDict = [String : Any]()
        iconDict["imageName"] = imageName ?? NSNull()
        
        result["userIcon"] = iconDict
        
        return result
    }
    
    
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
