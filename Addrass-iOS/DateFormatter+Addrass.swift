//
//  DateFormatter+Addrass.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 2/20/17.
//  Copyright © 2017 bsu. All rights reserved.
//

import Foundation

extension DateFormatter {

    static let dayNumberDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd";
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let weekdayDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE";
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let titleDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy";
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let dayShortNameDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM";
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let eventDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }()
    
    static let timeDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm";
        formatter.locale = Locale.current
        return formatter
    }()

}
