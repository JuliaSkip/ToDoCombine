//
//  TaskViewModel.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import Foundation
import Combine
import CoreData

final class TasksViewModel: ObservableObject {
    
    @Published private(set) var tasks: [Task] = []
    @Published var sortOption: SortOption = .defaultOrder
    @Published var filterText: String = ""
    
    private let taskService: CDTaskService!
    private var bag = Set<AnyCancellable>()
    
    let priorityRank: [String: Int] = [ Priority.high.rawValue: 3, Priority.medium.rawValue : 2, Priority.low.rawValue: 1]
    
    init(taskService: CDTaskService) {
        self.taskService = taskService
        
        Publishers.CombineLatest3(
            taskService.tasksPublisher,
            $sortOption,
            $filterText.debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
        )
        .map { [weak self] in
            guard let self else { return $0 }
            return handleChanges(for: $0, with: $1, filteredBy: $2)
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$tasks)
    }
    
    func delete(_ task: Task) {
        taskService.delete(entity: task)
    }
    
    func updateStatus(for task: Task) {
        taskService.updateStatus(for: task)
    }
    
    func getTasksSortedByDeadline(_ tasks: [Task]) -> [Task] {
        tasks.sorted { ($0.deadline ?? .distantFuture) < ($1.deadline ?? .distantFuture) }
    }

    func getTasksSortedByPriority(_ tasks: [Task]) -> [Task] {
        tasks.sorted { (priorityRank[$0.priority ?? ""] ?? 0) > (priorityRank[$1.priority ?? ""] ?? 0) }
    }

    func getTasksSortedByAllFields(_ tasks: [Task]) -> [Task] {

        return tasks.sorted { [weak self] lhs, rhs in
            guard let self else { return false }

            let predicates: [(Task, Task) -> Bool] = [
                { !$0.isDone && $1.isDone },
                { (self.priorityRank[$0.priority ?? ""] ?? 0) >
                    (self.priorityRank[$1.priority ?? ""] ?? 0) },
                { ($0.deadline ?? .distantFuture) <
                  ($1.deadline ?? .distantFuture) },
                { ($0.content ?? "")
                    .localizedCaseInsensitiveCompare($1.content ?? "")
                    == .orderedAscending }
            ]

            for predicate in predicates {
                if !predicate(lhs, rhs) && !predicate(rhs, lhs) { continue }
                return predicate(lhs, rhs)
            }

            return false
        }
    }
    
    private func handleChanges(for tasks: [Task], with sortOption: SortOption, filteredBy filterText: String ) -> [Task] {
        switch sortOption {
        case .defaultOrder: return self.getTasksSortedByAllFields(filter(tasks: tasks, with: filterText))
        case .dueDateOrder: return self.getTasksSortedByDeadline(filter(tasks: tasks, with: filterText))
        case .priorityOrder: return self.getTasksSortedByPriority(filter(tasks: tasks, with: filterText))
        }
    }
    
    private func filter (tasks: [Task], with filterText: String) -> [Task] {
        filterText.isEmpty ? tasks : tasks.filter { $0.content?.localizedCaseInsensitiveContains(filterText) ?? false}
    }
}
