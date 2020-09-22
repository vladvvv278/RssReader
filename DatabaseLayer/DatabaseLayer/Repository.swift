//
//  Repository.swift
//  DatabaseLayer
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Entity
    
    init(databaseName: String)
    
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>

    func create() -> Result<Entity, Error>

    func delete(entity: Entity) -> Result<Bool, Error>
    
    func deleteAll() -> Result<Bool, Error>
    
    func save()
}

protocol DomainRepository {
    associatedtype ManagedObjectType: DomainModel
    
    init(databaseName: String)

    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[ManagedObjectType.DomainModelType], Error>

    func create(entity: ManagedObjectType.DomainModelType) -> Result<Bool, Error>
    
    func deleteAll() -> Result<Bool, Error>
    
    func save()
}
