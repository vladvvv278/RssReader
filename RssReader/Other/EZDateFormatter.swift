//
//  EZDateFormatter.swift
//  RssReader
//
//  Created by vladislav on 21.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

@objc public final class EZDateFormatterWrapper: NSObject {
    
    @objc public static func defaultString(for date: Date, format: String) -> String  {
        return string(for: date, format: format)
    }
    
    @objc public static func defaultDate(for string: String, format: String) -> Date? {
        date(for: string, format: format)
    }
    
    @objc public static func string(for date: Date, format: String, timeZone: TimeZone = TimeZone(abbreviation: "GMT")!, locale: Locale = .init(identifier: "en_US_POSIX")) -> String  {
        EZDateFormatter.global.string(for: date, with: .init(format, timeZone: timeZone, locale: locale))
    }
    
    @objc public static func date(for string: String, format: String, timeZone: TimeZone = TimeZone(abbreviation: "GMT")!, locale: Locale = .init(identifier: "en_US_POSIX")) -> Date? {
        
        EZDateFormatter.global.date(for: string, with: .init(format, timeZone: timeZone, locale: locale))
    }
}

public final class EZDateFormatter {

    public static let global = EZDateFormatter()
    
    private var stack = [FormatterKey: DateFormatter]()
    
    public struct FormatterKey: Hashable {
        
        let format: String
        let timeZone: TimeZone
        let locale: Locale
        
        public init(_ format: String, timeZone: TimeZone = TimeZone(abbreviation: "GMT")!, locale: Locale = .init(identifier: "en_US_POSIX")) {
            self.format = format
            self.timeZone = timeZone
            self.locale = locale
        }
        
        public func hash(into hasher: inout Hasher) {
        
            hasher.combine(format.hashValue)
        }
    }
    
    public func string(for date: Date, with format: FormatterKey) -> String {
        
        formatter(for: format).string(from: date)
    }
    
    public func date(for string: String, with format: FormatterKey) -> Date? {
        
        formatter(for: format).date(from: string)
    }
    
    private func formatter(for format: FormatterKey) -> DateFormatter {
        
        if stack[format] == nil {
            let form = DateFormatter()
            form.dateFormat = format.format
            form.locale = format.locale
            form.timeZone = format.timeZone
            stack[format] = form
        }
        
        return stack[format]!
    }
}
