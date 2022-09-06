//
//  DBManager.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import Foundation

import CoreData

class DBManager {
    
    private static let DB_NAME = "AlderadahCareerAssignmentSumit"
    
    static let manager = DBManager()
    
//    var dbOperationQueue = DispatchQueue(label: "DBOperations")
    
    private init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DBManager.DB_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    static func getBackgroundModel<T:NSManagedObject>(t:T.Type) -> T {
        t.init(context: ASDBManager.backgroundManagedObjectContext)
    }
    
    static func getFrontModel<T:NSManagedObject>(t:T.Type) -> T {
        t.init(context: ASDBManager.managedObjectContext)
    }
    
    func managedContext(isBackgroundTask: Bool) -> NSManagedObjectContext {
        if isBackgroundTask {
            return self.backgroundManagedObjectContext
        }
        return persistentContainer.viewContext        
    }
}
