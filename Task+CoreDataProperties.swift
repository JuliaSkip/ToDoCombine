//
//  Task+CoreDataProperties.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 27.02.2026.
//
//

public import Foundation
public import CoreData


public typealias TaskCoreDataPropertiesSet = NSSet

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var content: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var priority: String?
    @NSManaged public var deadline: Date?

}

extension Task : Identifiable {

}

