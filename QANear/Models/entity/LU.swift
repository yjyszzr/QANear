//
//  LU+CoreDataClass.swift
//  QANear
//
//  Created by zzr on 2021/11/1.
//
//

import Foundation
import CoreData

public class LU: NSManagedObject,Managed {
    @NSManaged public var mobile: String?
    @NSManaged public var token: String?
    
    static func insert(into context: NSManagedObjectContext, mobile: String,token: String) -> LU {
        let lu: LU = context.insertObject()
        lu.mobile = mobile
        lu.token = token
        return lu
    }
}

extension LU {
    
    /// Get All ToDo Item and sort by Date
    /// - Returns: <#description#>
    static func getAllLUs() -> NSFetchRequest<LU> {
        let requst: NSFetchRequest<LU> = LU.fetchRequest() as! NSFetchRequest<LU>
        
        let sortDescriptor = NSSortDescriptor(key: "mobile", ascending: true)
        requst.sortDescriptors = [sortDescriptor]
        
        return requst
    }
}
