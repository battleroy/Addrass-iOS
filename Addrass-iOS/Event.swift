//
//  Event.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class Event {

    var id: Int?
    var timestamp: Int64?
    var name: String?
    var eventTypeName: String?
    var owner: User?
    
    
    convenience init() {
        self.init(withId: nil, timestamp: nil, name: nil, eventTypeName: nil, owner: nil)
    }
    
    
    init(withId id: Int?, timestamp: Int64?, name: String?, eventTypeName: String?, owner: User?) {
        self.id = id
        self.timestamp = timestamp
        self.name = name
        self.eventTypeName = eventTypeName
        self.owner = owner
    }
    
    
    func dictionaryRepresentation() -> [String : Any] {
        
        var result = Dictionary<String, Any>()
        
        result["id"] = id ?? NSNull()
        result["eventTimestamp"] = timestamp ?? NSNull()
        result["eventName"] = name ?? NSNull()
        
        if let eventTypeName = eventTypeName {
            var eventTypeDictionary = [String : String]()
            eventTypeDictionary["typeName"] = eventTypeName
            
            result["eventType"] = eventTypeDictionary
        }
        
        if let eventOwner = owner {
            result["userOwner"] = eventOwner.dictionaryRepresentation()
        }
        
        return result
    }
    
    
    static func event(withDictionary dict: [String : Any]) -> Event {
        let event = Event()
        
        event.id = dict["id"] as? Int
        
        if let eventTimestamp = dict["eventTimestamp"] {
            if let eventTimestamp32 = eventTimestamp as? Int {
                event.timestamp = Int64(exactly: eventTimestamp32)
            } else if let eventTimestamp64 = eventTimestamp as? Int64 {
                event.timestamp = eventTimestamp64
            }
        }
        
        event.name = dict["eventName"] as? String
        
        if let eventTypeDict = dict["eventType"] as? [String : Any] {
            event.eventTypeName = eventTypeDict["typeName"] as? String
        }

        if let eventOwnerDict = dict["userOwner"] as? [String : Any] {
            event.owner = User.user(withDictionary: eventOwnerDict)
        }
        
        return event
    }
    
    
    static func eventList(withDictionaryList dictList: [[String: Any]]) -> [Event]? {
        
        var result = [Event]()
        
        for eventDict in dictList {
            result.append(Event.event(withDictionary: eventDict))
        }
        
        return result
    }
    
    
    static func eventsGroupedByDate(_ eventsList: [Event]) -> [Date : [Event]] {
        
        var resultDict = [Date : [Event]]()
        
        for event in eventsList {
            if let eventTimestamp = event.timestamp {
                let eventDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: Double(eventTimestamp) / 1000.0))
                
                if resultDict[eventDate] == nil {
                    resultDict[eventDate] = [Event]()
                }
                
                resultDict[eventDate]?.append(event)
            }
        }
        
        return resultDict
    }

}
