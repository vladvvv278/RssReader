//
//  NetworkExtensions.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

extension String {
    
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw ApiError.invalidUrl }

        return url
    }
}
