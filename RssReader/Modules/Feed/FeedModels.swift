//
//  FeedModels.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public struct FeedViewData {
    let title: String
    let date: String
}

public enum FeedViewState {
    case empty
    case loading
    case loaded
}
