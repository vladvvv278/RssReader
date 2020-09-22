//
//  ParserProtocols.swift
//  RssParser
//
//  Created by vladislav on 18.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public protocol RssParsableModel {
    init(data: [AnyHashable: Any]) throws
}

public protocol RssParserManager {
    func parse<T: RssParsableModel> (data: Data, completion: @escaping(Swift.Result<[T], ParserError>) -> Void)
}
