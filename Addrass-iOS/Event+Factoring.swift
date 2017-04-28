//
//  Event+Factoring.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/20/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import UIKit


extension Event {
    
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
        
        event.isPublic = dict["public"] as? Bool ?? false
        
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
            if let eventDate = event.date {
                
                let eventDay = Calendar.current.startOfDay(for: eventDate)
                
                if resultDict[eventDay] == nil {
                    resultDict[eventDay] = [Event]()
                }
                
                resultDict[eventDay]?.append(event)
            }
        }
        
        return resultDict
    }

    
}
