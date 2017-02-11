//
//  APIManager+Events.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/11/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

extension APIManager {
    
    // MARK: Events
    
    static func create(_ event: Event, forOwner: User) -> Bool {
        fatalError()
    }
    
    
    static func events(forUser user: User) -> [Event] {
        fatalError()
    }
    
    
    static func update(_ userLogin: String, newEventData: Event) -> Bool {
        fatalError()
    }
    
    
    static func delete(_ userLogin: String, event: Event) -> Bool {
        fatalError()
    }
    
}
