//
//  DateExtensions.swift
//  RssReader
//
//  Created by vladislav on 21.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

extension Date {
    
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
}
