//
//  StompError.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 3/4/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

public enum StompError: Error {
    case badStompFrame
    case badUnsubscribeID
}


extension StompError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badStompFrame:
            return "Bad STOMP frame."
        case .badUnsubscribeID:
            return "Bad unsubscribe ID."
        }
    }
    
}
