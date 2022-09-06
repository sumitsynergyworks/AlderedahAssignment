//
//  DBExtension.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 03/09/22.
//

import Foundation
import CoreData

protocol ManagedContextBaseMethods {
//    var dbOperationQueue: DispatchQueue { get }

    func saveObject<T:NSManagedObject>(t:T, callBack: @escaping ((Bool, NSError?)->()))
    func fetchResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate?, sort: [NSSortDescriptor]?, callBack:@escaping (([T]?, NSError?)->()))
    func fetchOneResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate, sort: [NSSortDescriptor]?, callBack:@escaping ((T?, NSError?)->()))
//    func updateObject<T:NSManagedObject>(t:T, callBack: @escaping ((Bool, NSError?)->()))
    func updateObject(callBack: @escaping ((Bool, NSError?)->()))
    func deleteObject<T:NSManagedObject>(t:T, callBack: @escaping ((Bool, NSError?)->()))
}

//protocol ManagedObjectQuery where Self:NSManagedObject {
//    func fetchQuery<T:NSManagedObject>()-> NSFetchRequest<T>
//}

extension NSManagedObjectContext : ManagedContextBaseMethods {
    
    var dbOperationQueue: DispatchQueue {
        get {
            DispatchQueue(label: "DBOperations")
        }
    }

    func saveObject<T:NSManagedObject>(t:T, callBack: @escaping ((Bool, NSError?)->())) {
        dbOperationQueue.sync {
            do {
                try self.save()
                callBack(true, nil)
            } catch {
                callBack(false, error as NSError)
            }
        }
    }
    
    func fetchResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate?, sort: [NSSortDescriptor]?, callBack:@escaping (([T]?, NSError?)->())) {
        let fr = t.fetchRequest()
        fr.predicate = predicator
        fr.sortDescriptors = sort
        
        dbOperationQueue.async {
            do {
                let fd = try self.fetch(fr) as! [T]
                
                callBack(fd, nil)
            } catch {
                callBack(nil, error as NSError)
            }
        }
    }
    
    func fetchOneResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate, sort: [NSSortDescriptor]?, callBack:@escaping ((T?, NSError?)->())) {
        let fr = t.fetchRequest()
        fr.predicate = predicator
        fr.sortDescriptors = sort
        
        dbOperationQueue.async {
            do {
                let fd = try self.fetch(fr) as! [T]
                if (fd.count > 0) {
                    callBack(fd.first, nil)
                } else {
                    callBack(nil, NSError(domain: AppBundleIdentifier, code: 0, userInfo: [NSLocalizedDescriptionKey : "No Object Found"]))
                }
            } catch {
                callBack(nil, error as NSError)
            }
        }
    }
    
    func updateObject(callBack: @escaping ((Bool, NSError?)->())) {
        if self.hasChanges {
            dbOperationQueue.sync {
                do {
                    try self.save()
                    callBack(true, nil)
                } catch {
                    callBack(false, error as NSError)
                }
            }
        } else {
            callBack(false, NSError(domain: AppBundleIdentifier, code: 0, userInfo: [NSLocalizedDescriptionKey : "Nothing to update"]))
        }
    }
    
    func deleteObject<T:NSManagedObject>(t:T, callBack: @escaping ((Bool, NSError?)->())) {
        dbOperationQueue.sync {
            self.delete(t)
            do {
                try self.save()
                callBack(true, nil)
            } catch {
                callBack(false, error as NSError)
            }
        }
    }
}

extension DBManager {
    func saveObject<T:NSManagedObject>(t:T, isBackgroundTask: Bool = true, callBack: @escaping ((Bool, NSError?)->())) {
        var mc = t.managedObjectContext
        if mc == nil {
            mc = self.managedContext(isBackgroundTask: isBackgroundTask)
        }
        mc!.saveObject(t: t, callBack: callBack)
    }
    
    func fetchResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate?, sort: [NSSortDescriptor]?, isBackgroundTask: Bool = true, callBack:@escaping (([T]?, NSError?)->())) {
        let mc = self.managedContext(isBackgroundTask: isBackgroundTask)
        mc.fetchResult(t: t, predicator: predicator, sort: sort, callBack: callBack)
    }
    
    func fetchOneResult<T:NSManagedObject>(t:T.Type, predicator: NSPredicate, sort: [NSSortDescriptor]?, isBackgroundTask: Bool = true, callBack:@escaping ((T?, NSError?)->())) {
        let mc = self.managedContext(isBackgroundTask: isBackgroundTask)
        mc.fetchOneResult(t: t, predicator: predicator, sort: sort, callBack: callBack)
    }
    
    func updateObject<T:NSManagedObject>(t:T, isBackgroundTask: Bool = true, callBack: @escaping ((Bool, NSError?)->())) {
        var mc = t.managedObjectContext
        if mc == nil {
            mc = self.managedContext(isBackgroundTask: isBackgroundTask)
        }
        mc!.updateObject(callBack: callBack)
    }
    
    func updateMultipleObjects<T>(t: [T], isBackgroundTask: Bool = true, callBack: @escaping ((Bool, NSError?) -> ())) where T : NSManagedObject {
        if t.count > 0 {
            var mc = t.first?.managedObjectContext
            if mc == nil {
                mc = self.managedContext(isBackgroundTask: isBackgroundTask)
            }
            mc!.updateObject(callBack: callBack)
        } else {
            callBack(false, NSError(domain: AppBundleIdentifier, code: 0, userInfo: [NSLocalizedDescriptionKey : "Nothing to update"]))
        }
    }
    
    func deleteObject<T:NSManagedObject>(t:T, isBackgroundTask: Bool = true, callBack: @escaping ((Bool, NSError?)->())) {
        var mc = t.managedObjectContext
        if mc == nil {
            mc = self.managedContext(isBackgroundTask: isBackgroundTask)
        }
        mc!.deleteObject(t: t, callBack: callBack)
    }
    
    func deleteMultipleObjects<T>(t: [T], isBackgroundTask: Bool = true, callBack: @escaping ((Bool, NSError?) -> ())) where T : NSManagedObject {
        for i in t {
            self.deleteObject(t: i, isBackgroundTask: isBackgroundTask) { deleted, error in
                
            }
        }
    }
}
