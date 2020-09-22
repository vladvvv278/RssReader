//
//  FeedPresenter.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public final class FeedViewPresenter {
    
    // MARK: - Properties
    
    public weak var view: FeedViewInterface?
    
    fileprivate var viewData = [FeedViewData]()
    
    fileprivate let repo = PostRepository()
    
    fileprivate var scrollOnce = false
    
    fileprivate func getPosts() {
        repo.fetchPosts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case Result.success(let response):
                self.newViewData(data: response)
                self.reloadData()
                break
            case Result.failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    fileprivate func reloadData() {
        DispatchQueue.main.async {
            self.view?.updateData()
            self.view?.update(view: .loaded)
            self.scroll()
        }
    }
    
    fileprivate func scroll() {
        if !self.scrollOnce {
            self.scrollOnce = true
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.view?.scrollToItem(self.viewData.count/2)
            }
        }
    }
    
    fileprivate func newViewData(data: [Post]) {
        viewData = data.map { (item) -> FeedViewData in
            return getViewData(post: item)
        }
    }
    
    fileprivate func getViewData(post: Post) -> FeedViewData {
        return FeedViewData(title: post.title ?? "",
                            date: post.date?.timeAgo() ?? "")
    }
}


// MARK: - FeedPresener

extension FeedViewPresenter: FeedPresenter {
    
    public func loadData() {
        view?.update(view: .empty)
        getPosts()
        view?.update(view: .loading)
    }
    
    public func getNumberOfRows() -> Int {
        return viewData.count
    }
    
    public func getDataForRow(_ row: Int) -> FeedViewData? {
        return row < viewData.count ? viewData[row] : nil
    }
    
    public func didSelect(row: Int) {
        guard let url = repo.getUrl(row: row) else {
            return
        }
        view?.openUrl(url)
    }
}
