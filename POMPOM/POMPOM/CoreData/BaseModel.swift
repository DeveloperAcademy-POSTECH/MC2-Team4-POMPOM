//
//  BaseModel.swift
//  POMPOM
//
//  Created by 김남건 on 2022/06/16.
//

import Foundation
import CoreData

protocol BaseModel: NSManagedObject {
    func delete()
    static func byId<T: NSManagedObject>(id: NSManagedObjectID) -> T?
    static func all<T: NSManagedObject>() -> [T]
}

extension BaseModel {
    static var viewContext: NSManagedObjectContext {
        return CoreDataManager.shared.viewContext
    }
    
    func save() {
        CoreDataManager.shared.save()
    }
    
    func delete() {
        Self.viewContext.delete(self)
        CoreDataManager.shared.save()
    }
    
    static func byId<T> (id: NSManagedObjectID) -> T? where T: NSManagedObject {
        do {
            return try viewContext.existingObject(with: id) as? T
        } catch {
            print(error)
            return nil
        }
    }
    
    static func all<T>() -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}
