//
//  Date+String.swift
//  Scene
//
//  Created by Trevin Wisaksana on 27/01/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension Date {
    
    /*
    struct Formatter {
        
        static let rfc3339DateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        static let localeEnUsPosix = "en_US_POSIX"
        
        static let rfc3339: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: localeEnUsPosix)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = rfc3339DateFormat
            return formatter
        }()
        
    }
    
    var rfc3339: String { return Formatter.rfc3339.string(from: self) }
    */
    
    func getTime() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
}

