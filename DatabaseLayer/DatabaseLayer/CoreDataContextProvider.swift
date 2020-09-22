//
//  CoreDataContextProvider.swift
//  DatabaseLayer
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataContextProvider {
    
    static let shared = CoreDataContextProvider()
    
    // MARK: - Properties
    
    private var initialized = false

    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    public func getContext() -> NSManagedObjectContext {
        return managedObjectContext
    }
    
    func openDatabase(modelName: String) {
        if initialized {
            return
        }
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: getManagedObjectModel(modelName: modelName))

        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
            initialized = true
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
    }

    // MARK: - Core Data Stack
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    private func getManagedObjectModel(modelName: String) -> NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }
    
}
