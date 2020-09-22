//
//  PostRepository.swift
//  RssReader
//
//  Created by vladislav on 21.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

class PostRepository: BaseRepository<Post, PostMO> {
    
    func fetchPosts(completion: @escaping(Swift.Result<[Post], RepositoryErrors>) -> Void) {
        let sort = NSSortDescriptor.init(key: PostMO.Fields.date, ascending: true)
        let dbData = self.getFromDB(predicate: nil, sortDescriptors: [sort])
        if dbData.count > 0 {
            completion(Result.success(dbData))
        }
        if (Reachability.isConnectedToNetwork()) {
            updateFromNetwork(completion: completion)
        }
    }
    
    func updateFromNetwork(completion: @escaping(Swift.Result<[Post], RepositoryErrors>) -> Void) {
        if (!Reachability.isConnectedToNetwork()) {
            completion(Result.failure(.noIntenetConnection))
            return
        }
        deleteAll()
        let group = DispatchGroup()
        for item in ApiRouter.allCases {
            group.enter()
            networkManager.getFeed(urlConvertible: item) { (result: Result<[Post], Error>) in
                switch result {
                case Result.success(let response):
                    self.saveToDB(data: response)
                case Result.failure(let error):
                    print(error.localizedDescription)
                    completion(Result.failure(.unavailable))
                }
                group.leave()
            }
        }
        group.notify(queue: .global()) {
            let sort = NSSortDescriptor.init(key: PostMO.Fields.date, ascending: true)
            let dbData = self.getFromDB(predicate: nil, sortDescriptors: [sort])
            completion(Result.success(dbData))
        }
    }
    
    func getUrl(row: Int) -> URL? {
        let sort = NSSortDescriptor.init(key: PostMO.Fields.date, ascending: true)
        let dbData = self.getFromDB(predicate: nil, sortDescriptors: [sort])
        if row >= dbData.count {
            return nil
        }
        guard let link = dbData[row].link else {
            return nil
        }
        return URL.init(string: link)
    }
    
    
    
}
