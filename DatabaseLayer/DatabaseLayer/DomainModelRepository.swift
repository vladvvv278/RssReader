//
//  DomainModelRepository.swift
//  DatabaseLayer
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import CoreData

public class DomainModelRepository<MO: DomainModel>: DomainRepository {
    
    typealias ManagedObjectType = MO
    
    fileprivate let repository: CoreDataRepository<ManagedObjectType>
    
    required public init(databaseName: String) {
        self.repository = CoreDataRepository<MO>(databaseName: databaseName)
    }
    
    public func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[MO.DomainModelType], Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: sortDescriptors)
        switch result {
        case .success(let resultsMO):
            let domainObjects = resultsMO.map { itemMO -> MO.DomainModelType in
                return itemMO.toDomainModel()
            }
            
            return .success(domainObjects)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func create(entity: MO.DomainModelType) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let objectMO):
            objectMO.createFromDomainModel(entity)
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func deleteAll() -> Result<Bool, Error> {
        return repository.deleteAll()
    }
    
    public func save() {
        repository.save()
    }
}
