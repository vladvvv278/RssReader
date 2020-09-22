//
//  ApiProtocols.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public protocol URLConvertible {
    func asURL() throws -> URL
}

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

public protocol ApiManager {
    func request(_ urlConvertable: URLConvertible, completion: @escaping(Swift.Result<Data, ApiError>) -> Void)
    
    func request<T: Decodable> (_ urlConvertible: URLRequestConvertible, completion: @escaping(Swift.Result<T, ApiError>) -> Void)
    
    func getImage(url: URL, completion: @escaping(Swift.Result<Data, ApiError>) -> Void)
}
