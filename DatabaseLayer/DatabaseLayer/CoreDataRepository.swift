//
//  CoreDataRepository.swift
//  DatabaseLayer
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case invalid
}

class CoreDataRepository<T: NSManagedObject>: Repository {
    
    typealias Entity = T

    private let managedObjectContext: NSManagedObjectContext

    required init(databaseName: String) {
        CoreDataContextProvider.shared.openDatabase(modelName: databaseName)
        self.managedObjectContext = CoreDataContextProvider.shared.getContext()
    }

    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        let className = String(describing: Entity.self)
        let fetchRequest = NSFetchRequest<Entity>(entityName: className)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest)
            return .success(fetchResults)
        } catch {
            return .failure(error)
        }
    }

    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalid)
        }
        return .success(managedObject)
    }

    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
    func deleteAll() -> Result<Bool, Error> {
        let className = String(describing: Entity.self)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: className)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(deleteRequest)
            return .success(true)
        } catch let error as NSError {
            return .failure(error)
        }
    }
    
    func save() {
        managedObjectContext.performAndWait {
            do {
                try managedObjectContext.save()
            } catch {
                managedObjectContext.rollback()
            }
        }
    }
}
