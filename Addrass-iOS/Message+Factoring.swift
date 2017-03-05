//
//  Message+Factoring.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 3/5/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation


extension Message {
    
    static func message(withDictionary dict: [String : Any]) -> Message {
        let message = Message()
        
        message.id = dict["id"] as? Int
        
        if let senderDict = dict["messageSender"] as? [String : Any] {
            message.sender = User.user(withDictionary: senderDict)
        }
        
        if let receiverDict = dict["messageReceiver"] as? [String : Any] {
            message.receiver = User.user(withDictionary: receiverDict)
        }
        
        if let contentDict = dict["message"] as? [String : Any] {
            message.text = contentDict["messageText"] as? String
        }
        
        if let messageTimestamp = dict["messageTime"] {
            if let messageTimestamp32 = messageTimestamp as? Int {
                message.timestamp = Int64(exactly: messageTimestamp32)
            } else if let messageTimestamp64 = messageTimestamp as? Int64 {
                message.timestamp = messageTimestamp64
            }
        }
        
        return message
    }
    
    
    static func messageList(withDictionaryList dictList: [[String: Any]]) -> [Message]? {
        
        var result = [Message]()
        
        for eventDict in dictList {
            result.append(Message.message(withDictionary: eventDict))
        }
        
        return result
    }

    
}
