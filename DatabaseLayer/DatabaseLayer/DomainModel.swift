//
//  DomainModel.swift
//  DatabaseLayer
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation
import CoreData

public protocol DomainModel: NSManagedObject {
    associatedtype DomainModelType
    func createFromDomainModel(_ model: DomainModelType)
    func toDomainModel() -> DomainModelType
}
