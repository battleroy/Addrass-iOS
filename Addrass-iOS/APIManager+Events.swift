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
    
    static let eventDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    // MARK: Events
    
    static func create(_ event: Event, forOwner: User) -> Bool {
        fatalError()
    }
    
    
    static func events(fromDate from: Date, to: Date, completion: @escaping (([Event]?, String?) -> Void)) {
        
        let endpoint = "/event/\(eventDateFormatter.string(from: from))/\(eventDateFormatter.string(from: to))"
        
        Alamofire.request(apiRoot + endpoint).responseJSON { response in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch events.")
                return
            }
            
            completion(Event.eventList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    static func update(_ userLogin: String, newEventData: Event) -> Bool {
        fatalError()
    }
    
    
    static func delete(_ userLogin: String, event: Event) -> Bool {
        fatalError()
    }
    
}
