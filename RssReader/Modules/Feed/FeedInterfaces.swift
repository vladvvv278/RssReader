//
//  FeedInterfaces.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public protocol FeedViewInterface: class {
    var presenter: FeedPresenter? { get set }
    
    func update(view state: FeedViewState)
    
    func updateData()
    
    func scrollToItem(_ item: Int)
    
    func openUrl(_ url: URL)
}

public protocol FeedPresenter {
    var view: FeedViewInterface? { get set }
    
    func loadData()
    
    func getNumberOfRows() -> Int
    
    func getDataForRow(_ row: Int) -> FeedViewData?
    
    func didSelect(row: Int)
}
