//
//  Event.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 19/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit

class Event {
    
    enum EventType: String, Hashable {
        case other = "other"
        case birthday = "birthday"
        case meeting = "meeting"
        case home = "home"
        case work = "work"
        case sport = "sport"
        case kids = "kids"
        
        
        // MARK: Properties
        
        var stringValue: String {
            switch self {
            case .other:
                return String.ad.others
            case .birthday:
                return String.ad.birthday
            case .meeting:
                return String.ad.meeting
            case .home:
                return String.ad.home
            case .work:
                return String.ad.work
            case .sport:
                return String.ad.sport
            case .kids:
                return String.ad.kids
            }
        }
        
        
        // MARK: Init
        
        init(stringValue value: String?) {
            guard let valueToConvert = value else {
                self = .other
                return
            }
            
            switch valueToConvert {
            case String.ad.birthday:
                self = .birthday
            case String.ad.meeting:
                self = .meeting
            case String.ad.home:
                self = .home
            case String.ad.work:
                self = .work
            case String.ad.sport:
                self = .sport
            case String.ad.kids:
                self = .kids
            default:
                self = .other
            }
        }
        
        
        // MARK: Hashable
        
        var hashValue: Int {
            return rawValue.hashValue
        }
        
        static func == (lhs: EventType, rhs: EventType) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        
        // MARK: Public methods
        
        static var allValues: [EventType] {
            return [.other, .birthday, .meeting, .home, .work, .sport, .kids]
        }
        
    }

    
    // MARK: Fields
    
    var id: Int?
    var timestamp: Int64?
    var name: String?
    var eventTypeName: String?
    var owner: User?
    
    
    // MARK: Properties
    
    var date: Date? {
        get {
            guard let eventTimestamp = timestamp else {
                return nil
            }
            
            return Date(timeIntervalSince1970: Double(eventTimestamp) / 1000.0)
        }
        
        set(newDate) {
            guard let dateToConvert = newDate else {
                timestamp = nil
                return
            }
            
            timestamp = Int64(dateToConvert.timeIntervalSince1970 * 1000.0)
        }
    }
    
    
    var type: EventType {
        get {
            guard let typeName = eventTypeName else {
                return .other
            }
            
            return EventType(rawValue: typeName)!
        }
        
        set(newType) {
            eventTypeName = newType.rawValue
        }
    }
    
    
    var isOwnedByCurrentUser: Bool {
        get {
            return owner?.id == SessionManager.currentUser?.id
        }
    }
    
    
    // MARK: Initialization
    
    convenience init() {
        self.init(withId: nil, timestamp: nil, name: String.ad.newEvent, eventTypeName: nil, owner: SessionManager.currentUser)
        self.date = Date()
        self.type = .other
    }
    
    
    init(withId id: Int?, timestamp: Int64?, name: String?, eventTypeName: String?, owner: User?) {
        self.id = id
        self.timestamp = timestamp
        self.name = name
        self.eventTypeName = eventTypeName
        self.owner = owner
    }
    
    
    // MARK: Public methods
    
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
    
}
