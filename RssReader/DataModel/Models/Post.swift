//
//  Post.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import UIKit
import RssParser

public class Post: RssParsableModel {
    
    var title: String?
    var date: Date?
    var link: String?
    
    init(mTitle: String, mLink: String, mDate: Date) {
        title = mTitle
        link = mLink
        date = mDate
    }
    
    required public init(data: [AnyHashable: Any]) throws {
        if let tTitle = data["title"] as? String {
            if tTitle == "iOS Programming" {
                print(tTitle)
            }
            title = tTitle
        } else {
            throw ParserError.emptyField
        }
        if let tLink = data["link"] as? String {
            link = tLink
        } else {
            throw ParserError.emptyField
        }
        if let tDate = data["pubDate"] as? String {
            date = tDate.dateFromRssString()
        } else {
            throw ParserError.emptyField
        }
        
    }
    
}
