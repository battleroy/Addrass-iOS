//
//  APIManager+Events.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/11/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation
import Alamofire


extension APIManager {
    
    // MARK: Events
    
    static func createEvent(_ event: Event) -> Bool {
        fatalError()
    }
    
    
    @discardableResult
    static func events(fromDate from: Date, to: Date, completion: @escaping (([Event]?, String?) -> Void)) -> DataRequest {
        
        let eventDateFormatter = DateFormatter.eventDateFormatter
        
        let endpoint = "/event/\(eventDateFormatter.string(from: from))/\(eventDateFormatter.string(from: to))"
        
        return Alamofire.request(apiRoot + endpoint).responseJSON { response in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch events.")
                return
            }
            
            completion(Event.eventList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    static func updateEvent(_ newEventData: Event) -> Bool {
        fatalError()
    }
    
    
    static func deleteEvent(_ event: Event) -> Bool {
        fatalError()
    }
    
}
