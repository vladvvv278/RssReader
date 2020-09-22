//
//  ApiRouter.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import NetworkLayer

enum ApiRouter: URLConvertible, CaseIterable {
    
    case getCipherFeed
    case getBBCFeed
    case getCnnFeed
    
    //MARK: - URLConvertible
    func asURL() throws -> URL {
        let url = try path.asURL()
        return url
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getCipherFeed:
            return "https://www.thecipherbrief.com/feed"
        case .getBBCFeed:
            return "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml"
        case .getCnnFeed:
            return "http://rss.cnn.com/rss/cnn_topstories.rss"
        }
    }
}
