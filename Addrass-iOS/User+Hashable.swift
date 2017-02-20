//
//  User+Hashable.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/21/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

extension User: Hashable {
    
    var hashValue: Int {
        return id ?? 0
    }
    
    
    static func== (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
}
