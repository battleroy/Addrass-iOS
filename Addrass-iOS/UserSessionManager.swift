//
//  SessionManager.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/12/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class UserSessionManager {
    
    // MARK: Properties
    
    private(set) var currentUser: User?
    
    static var sharedManager: UserSessionManager = {
        let manager = UserSessionManager()
        return manager
    }()
    
    
    // MARK: Public methods
    
    func refreshSessionUser(completion: @escaping (User?, String?) -> Void) {
        APIManager.sharedManager.sessionUser { (fetchedSessionUser, fetchError) in
            guard let sessionUser = fetchedSessionUser else {
                completion(nil, fetchError!)
                return
            }
            
            weak var weakSelf: UserSessionManager! = self
            
            weakSelf.currentUser = sessionUser
            completion(weakSelf.currentUser, nil)
        }
    }

    
    func invalidateSession() {
        self.currentUser = nil
    }
}
