//
//  APIManager.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class APIManager: NSObject {

    // MARK: Users
    
    func register(_ user: User) -> Bool {
        fatalError()
    }
    
    
    func areCredentialsValid(forLogin login: String, password: String) -> Bool {
        fatalError()
    }
    
    
    func user(byLogin login: String) -> User {
        fatalError()
    }
    
    
    func update(_ userLogin: String, newUserData: User) -> Bool {
        fatalError()
    }
    
    
    func delete(_ userLogin: String, user: User) -> Bool {
        fatalError()
    }
    
    
    // MARK: Events
    
    func create(_ event: Event, forOwner: User) -> Bool {
        fatalError()
    }
    
    
    func events(forUser user: User) -> [Event] {
        fatalError()
    }
    
    
    func update(_ userLogin: String, newEventData: Event) -> Bool {
        fatalError()
    }
    
    
    func delete(_ userLogin: String, event: Event) -> Bool {
        fatalError()
    }
    
}
