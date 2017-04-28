//
//  APIManager+Chat.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 3/5/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import Alamofire


extension APIManager {
    
    // MARK: Chat
    
    func messages(withFriendLogin friendLogin: String, completion: @escaping (([Message]?, String?) -> Void)) {
        
        let endpoint = "/message/\(friendLogin)"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint).responseJSON { response in
            switch response.result {
            case .success:
                guard let JSON = response.result.value as? [[String : Any]] else {
                    completion(nil, "Can't fetch messages.")
                    return
                }
                
                completion(Message.messageList(withDictionaryList: JSON), nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
        
    }
    
}
