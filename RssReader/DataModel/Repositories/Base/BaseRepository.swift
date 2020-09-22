//
//  BaseRepository.swift
//  RssReader
//
//  Created by vladislav on 21.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import DatabaseLayer

class BaseRepository<T, MO: DomainModel> {
    
    var networkManager = NetworkManager.init()
    
    lazy var dbRepo:  DomainModelRepository<MO> = {
        return DomainModelRepository<MO>.init(databaseName: Constants.modelName)
    }()
    
    func updateDatabase() {
        dbRepo.save()
    }
    
    func getFromDB(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [MO.DomainModelType] {
        let result = dbRepo.get(predicate: predicate, sortDescriptors: sortDescriptors)
        switch result {
        case Result.success(let data):
            return data
        case Result.failure(let error):
            print(error.localizedDescription)
            return []
        }
    }
    
    func saveToDB(data: [MO.DomainModelType]) {
        for item in data {
            let result = dbRepo.create(entity: item)
            switch result {
            case Result.success(_):
                break
            case Result.failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        updateDatabase()
    }
    
    func deleteAll() {
        let result = dbRepo.deleteAll()
        switch result {
        case .success(_):
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
