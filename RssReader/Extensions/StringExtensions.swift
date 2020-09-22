//
//  StringExtensions.swift
//  RssReader
//
//  Created by vladislav on 21.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

extension String {
    
    func dateFromRssString() -> Date {
        EZDateFormatterWrapper.date(for: self, format: "E, d MMM yyyy HH:mm:ss Z") ?? Date()
    }
    
}
