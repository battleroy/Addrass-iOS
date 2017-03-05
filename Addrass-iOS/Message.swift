//
//  Message.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/27/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

class Message {
    
    // MARK: Fields
    
    var id: Int?
    var sender: User?
    var receiver: User?
    var text: String?
    var timestamp: Int64?
    
    
    // MARK: Properties
    
    var date: Date? {
        get {
            guard let messageTimestamp = timestamp else {
                return nil
            }
            
            return Date(timeIntervalSince1970: Double(messageTimestamp) / 1000.0)
        }
        
        set(newDate) {
            guard let dateToConvert = newDate else {
                timestamp = nil
                return
            }
            
            timestamp = Int64(dateToConvert.timeIntervalSince1970 * 1000.0)
        }
    }
    
    
    // MARK: Initialization
    
    convenience init() {
        self.init(withID: nil, sender: nil, receiver: nil, text: nil, timestamp: nil)
    }
    
    
    init(withID id: Int?, sender: User?, receiver: User?, text: String?, timestamp: Int64?) {
        self.id = id
        self.sender = sender
        self.receiver = receiver
        self.text = text
        self.timestamp = timestamp
    }
    
    
    // MARK: Public methods
    
    func dictionaryRepresentation() -> [String : Any] {
        
        var result = [String : Any]()
        
        result["id"] = id ?? NSNull()
        result["messageSender"] = sender?.dictionaryRepresentation() ?? NSNull()
        result["messageReceiver"] = receiver?.dictionaryRepresentation() ?? NSNull()

        if let messageID = id, let messageText = text {
            var contentDict = [String : Any]()
            contentDict["id"] = messageID
            contentDict["messageText"] = messageText
            result["message"] = contentDict
        }
        
        result["messageTime"] = timestamp ?? NSNull()
        
        return result
    }

    
}
