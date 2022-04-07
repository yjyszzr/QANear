//
//  ToDoItem.swift
//  ToDoCoreData
//
//  Created by BaronZhang on 2020/10/13.
//

import Foundation
import CoreData

public class ToDoItem: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
}

extension ToDoItem {
    
    /// Get All ToDo Item and sort by Date
    /// - Returns: <#description#>
    static func getAllToDoItems() -> NSFetchRequest<ToDoItem> {
        let requst: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest() as! NSFetchRequest<ToDoItem>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        requst.sortDescriptors = [sortDescriptor]
        
        return requst
    }
}
