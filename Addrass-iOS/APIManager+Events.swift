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
    
    @discardableResult
    func events(fromDate from: Date, to: Date, completion: @escaping (([Event]?, String?) -> Void)) -> DataRequest {
        let eventDateFormatter = DateFormatter.eventDateFormatter
        let endpoint = "/event/\(eventDateFormatter.string(from: from))/\(eventDateFormatter.string(from: to))"
        
        return self.events(forEndpoint: endpoint, completion: completion)
    }
    
    
    @discardableResult
    func eventsForOwn(completion: @escaping (([Event]?, String?) -> Void)) -> DataRequest {
        let endpoint = "/event"
        
        return self.events(forEndpoint: endpoint, completion: completion)
    }
    
    
    private func events(forEndpoint endpoint: String, completion: @escaping (([Event]?, String?) -> Void)) -> DataRequest {
        return self.sessionManager.request(APIManager.apiRoot + endpoint).responseJSON { response in
            guard let JSONList = response.result.value as? [[String: Any]] else {
                completion(nil, "Can't fetch events.")
                return
            }
            
            completion(Event.eventList(withDictionaryList: JSONList), nil)
        }
    }
    
    
    func createEvent(_ event: Event, completion: @escaping ((Event?, String?) -> Void)) {
        
        let endpoint = "/event"
        let eventDict = event.dictionaryRepresentation()
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: .post, parameters: eventDict, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(Event.event(withDictionary: response.result.value as! [String : Any]), nil)
                case .failure(let createError):
                    completion(nil, createError.localizedDescription)
                }
        }
        
    }
    
    
    func updateEvent(_ newEventData: Event, completion: @escaping ((String?) -> Void)) {
        let endpoint = "/event"
        let eventDict = newEventData.dictionaryRepresentation()
     
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: .put, parameters: eventDict, encoding: JSONEncoding.default)
        .validate(statusCode: 200..<300)
        .responseData { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let updateError):
                completion(updateError.localizedDescription)
            }
        }
    }
    
    
    func deleteEvent(forEventID eventID: Int, completion: @escaping ((String?) -> Void)) {
        let endpoint = "/event/\(eventID)"
        
        self.sessionManager.request(APIManager.apiRoot + endpoint, method: .delete)
        .responseData { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let deleteError):
                completion(deleteError.localizedDescription)
            }
        }
    }
    
}
