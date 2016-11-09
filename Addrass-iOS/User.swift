//
//  User.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 09/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class User: NSObject {

    var name:   String?
    var group:  String?
    var image:  UIImage?
    var color:  UIColor?
    
    convenience override init() {
        self.init(withName: nil, group: nil, image: nil, color: nil)
    }
    
    
    init(withName name: String?, group: String?, image: UIImage?, color: UIColor?) {
        super.init()
        
        self.name = name
        self.group = group
        self.image = image
        self.color = color
    }
}
