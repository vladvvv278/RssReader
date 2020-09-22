//
//  Post+CoreDataClass.swift
//  
//
//  Created by vladislav on 20.09.2020.
//
//

import Foundation
import CoreData
import DatabaseLayer

@objc(PostMO)
public class PostMO: NSManagedObject {

}

extension PostMO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostMO> {
        return NSFetchRequest<PostMO>(entityName: "PostMO")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var date: Date?
    
    struct Fields {
        static let title = "title"
        static let url = "url"
        static let date = "date"
    }

}

extension PostMO: DomainModel {
    
    public typealias DomainModelType = Post
    
    public func createFromDomainModel(_ model: DomainModelType) {
        title = model.title
        url = model.link
        date = model.date
    }
    
    public func toDomainModel() -> DomainModelType {
        let post = Post.init(mTitle: title ?? "", mLink: url ?? "", mDate: date ?? Date())
        return post
    }
    
}
