//
//  SessionManager.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 17/12/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class SessionManager {
    
    // MARK: Variables
    
    static var currentUser: User?
    
    
    // MARK: Public methods
    
    static func refreshSessionUser(completion: @escaping (String?) -> Void) {
        APIManager.sessionUser { (fetchedSessionUser, fetchError) in
            guard let sessionUser = fetchedSessionUser else {
                completion(fetchError!)
                return
            }
            
            currentUser = sessionUser
            completion(nil)
        }
    }

}
