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
    
    // MARK: Event members
    
    func membersFromEvent(forEventID eventID: Int, completion: @escaping ([User]?, String?) -> Void) {
        let endpoint = "/member/\(eventID)"
        self.members(endpoint, completion: completion)
    }
    
    
    func friendsNotInEvent(forEventID eventID: Int, completion: @escaping ([User]?, String?) -> Void) {
        let endpoint = "/member/not/\(eventID)"
        self.members(endpoint, completion: completion)
    }
    
    
    private func members(_ endpoint: String, completion: @escaping ([User]?, String?) -> Void) {
        
        self.sessionManager.request(APIManager.apiRoot + endpoint).responseJSON { responseData in
            switch responseData.result {
            case .success:
                completion(User.userList(withDictionaryList: responseData.result.value as! [[String : Any]]), nil)
                break
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    func membersUpdate(forEventID eventID: Int, newMembers: [User]?, completion: @escaping ((String?) -> Void)) {
        
        self.membersFromEvent(forEventID: eventID) { (fetchedMembers, membersErrorText) in
            guard let members = fetchedMembers else {
                completion(membersErrorText!)
                return
            }
            
            weak var weakSelf: APIManager! = self
            
            weakSelf.friendsNotInEvent(forEventID: eventID) { (fetchedNotMembers, notMembersErrorText) in
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
                    weakSelf.eventMemberRequest(forEventID: eventID, friendLogin: add.login!, method: .post) { fetchedAddError in
                        if errorText == nil {
                            errorText = fetchedAddError
                        }
                        
                        requestDispatchGroup.leave()
                    }
                }
                
                for remove in friendsToRemove {
                    weakSelf.eventMemberRequest(forEventID: eventID, friendLogin: remove.login!, method: .delete) { fetchedAddError in
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
    
    
    private func eventMemberRequest(forEventID eventID: Int, friendLogin: String, method: HTTPMethod, completion: @escaping ((String?) -> Void)) {
        
        let endpoint = "/member/\(eventID)/\(friendLogin)"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: method).responseData { responseData in
            switch responseData.result {
            case .success:
                completion(nil)
            case .failure(let requestError):
                completion(requestError.localizedDescription)
            }
        }
    }
    
}
