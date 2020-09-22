//
//  Requests.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import NetworkLayer
import RssParser

class NetworkManager {
    
    fileprivate let apiManager: ApiManager = UrlSessionManager.init()
    fileprivate let rssParser: RssParserManager = XmlParserManager.init()

    func getFeed<T: RssParsableModel> (urlConvertible: URLConvertible, completion: @escaping(Swift.Result<[T], Error>) -> Void) {
        apiManager.request(urlConvertible) { (result: Swift.Result<Data, ApiError>) in
            switch result {
            case Result.success(let response):
                self.parse(data: response, completion: completion)
                break
            case Result.failure(let error):
                completion(Result.failure(error))
                break
            }
        }
    }
    
    fileprivate func parse<T: RssParsableModel> (data: Data, completion: @escaping(Swift.Result<[T], Error>) -> Void) {
        rssParser.parse(data: data) { (parseResult: Swift.Result<[T], ParserError>) in
            switch parseResult {
            case Result.success(let response):
                completion(Result.success(response))
                break
            case Result.failure(let error):
                completion(Result.failure(error))
                break
            }
        }
    }

}
