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
    
    
    static func membersUpdate(forEventID eventID: Int, newMembers: [User]?, completion: @escaping ((String?) -> Void)) {
        
        membersFromEvent(forEventID: eventID) { (fetchedMembers, membersErrorText) in
            guard let members = fetchedMembers else {
                completion(membersErrorText!)
                return
            }
            
            friendsNotInEvent(forEventID: eventID) { (fetchedNotMembers, notMembersErrorText) in
                guard let notMembers = fetchedNotMembers else {
                    completion(notMembersErrorText!)
                    return
                }
                
                var friendsToAdd = [User]()
                var friendsToRemove = [User]()
                let requestDispatchGroup = DispatchGroup()
                
                if let membersToSet = newMembers {
                    
                    for member in members {
                        if !membersToSet.contains(member) {
                            friendsToRemove.append(member)
                            requestDispatchGroup.enter()
                        }
                    }
                    
                    for notMember in notMembers {
                        if membersToSet.contains(notMember) {
                            friendsToAdd.append(notMember)
                            requestDispatchGroup.enter()
                        }
                    }
                    
                } else {
                    friendsToRemove.append(contentsOf: members)
                }
                
                var errorText: String?
                
                for add in friendsToAdd {
                    eventMemberRequest(forEventID: eventID, friendLogin: add.login!, method: .post) { fetchedAddError in
                        if errorText == nil {
                            errorText = fetchedAddError
                        }
                        
                        requestDispatchGroup.leave()
                    }
                }
                
                for remove in friendsToRemove {
                    eventMemberRequest(forEventID: eventID, friendLogin: remove.login!, method: .delete) { fetchedAddError in
                        if errorText == nil {
                            errorText = fetchedAddError
                        }
                        
                        requestDispatchGroup.leave()
                    }
                }
                
                requestDispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(errorText)
                }
            }
        }
        
    }
    
    
    private static func eventMemberRequest(forEventID eventID: Int, friendLogin: String, method: HTTPMethod, completion: @escaping ((String?) -> Void)) {
        
        let endpoint = "/member/\(eventID)/\(friendLogin)"
        
        Alamofire.request(apiRoot + endpoint, method: method).responseData { responseData in
            switch responseData.result {
            case .success:
                completion(nil)
            case .failure(let requestError):
                completion(requestError.localizedDescription)
            }
        }
    }
    
}
