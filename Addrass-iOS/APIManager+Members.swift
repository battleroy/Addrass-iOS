//
//  APIManager+Members.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/20/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import Alamofire


extension APIManager {
    
    static func membersFromEvent(forEventID eventID: Int, completion: @escaping ([User]?, String?) -> Void) {
        let endpoint = "/member/\(eventID)"
        members(endpoint, completion: completion)
    }
    
    
    static func friendsNotInEvent(forEventID eventID: Int, completion: @escaping ([User]?, String?) -> Void) {
        let endpoint = "/member/not/\(eventID)"
        members(endpoint, completion: completion)
    }
    
    
    private static func members(_ endpoint: String, completion: @escaping ([User]?, String?) -> Void) {
        
        Alamofire.request(apiRoot + endpoint).responseJSON { responseData in
            switch responseData.result {
            case .success:
                completion(User.userList(withDictionaryList: responseData.result.value as! [[String : Any]]), nil)
                break
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    
    
}
