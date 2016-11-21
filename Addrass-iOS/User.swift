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
    var image:    UIImage?
    var color:    UIColor?
    var phone:    String?
    var email:    String?
    var company:  String?
    var address:  String?
    var notes:    String?
    var friends:  [User]?
    var blacklist: [User]?
    
//    convenience override init() {
//        self.init(withName: nil, group: nil, image: nil, color: nil)
//    }
    
    
    init(withName name: String?, group: String?, image: UIImage?, color: UIColor?, phone: String?, email: String?, company: String?, address: String?, notes: String?) {
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
}
