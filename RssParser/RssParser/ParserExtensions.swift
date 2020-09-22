//
//  ParserExtensions.swift
//  RssParser
//
//  Created by vladislav on 18.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }

    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}
