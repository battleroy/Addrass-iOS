//
//  Event.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class Event: NSObject {

    var eventID: UInt64!
    var name: String?
    var owner: User!
    var members: [User]!
    var date: NSDate!
    var type: String?
    var latitude: Double?
    var longitude: Double?
    
    
}
