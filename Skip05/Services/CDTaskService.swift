//
//  CDTaskService.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import CoreData
import Combine

class CDTaskService {
    
    private let context: NSManagedObjectContext
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    var tasksPublisher: AnyPublisher<[Task], Never> { tasksSubject.eraseToAnyPublisher() }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchAll()
    }
    
    func fetchAll() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "content", ascending: true)]
        
        do {
            let tasks = try context.fetch(request)
            tasksSubject.send(tasks)
        } catch {
            print("CoreData fetch error: \(error)")
            tasksSubject.send([])
        }
    }
    
    func createTaskWith(content: String, deadline: Date?, priority: String) {
        let entity = Task(context: context)
        entity.content = content
        entity.deadline = deadline
        entity.priority = priority
        entity.isDone = false
        saveContext()
    }
    
    func delete(entity: Task) {
        context.delete(entity)
        saveContext()
    }
    
    func update(content: String, deadline: Date?, priority: String, for entity: Task) {
        entity.content = content
        entity.deadline = deadline
        entity.priority = priority
        saveContext()
    }
    
    func updateStatus(for entity: Task) {
        entity.isDone.toggle()
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
            fetchAll()
        } catch {
            print("CoreData save error: \(error)")
        }
    }
}
