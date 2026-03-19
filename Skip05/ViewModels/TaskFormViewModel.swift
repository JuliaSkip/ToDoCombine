//
//  TaskFormViewModel.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 26.02.2026.
//

import SwiftUI
import Combine

final class TaskFormViewModel: ObservableObject {
    
    @Published var text: String
    @Published var deadline: Date?
    @Published var priority: Priority
    @Published private(set) var isSaveEnabled: Bool = false
    
    private var bag = Set<AnyCancellable>()
    private let taskService: CDTaskService
    private let taskToEdit: Task?
    
    init( taskService: CDTaskService, taskToEdit: Task? = nil ) {
        self.taskService = taskService
        self.taskToEdit = taskToEdit
        self.text = taskToEdit?.content ?? ""
        self.deadline = taskToEdit?.deadline ?? Date()
        self.priority = taskToEdit?.priority.flatMap { Priority(rawValue: $0) } ?? .low
        
        $text
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .assign(to: \.isSaveEnabled, on: self)
            .store(in: &bag)
    }
    
    func save() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if let task = taskToEdit {
            taskService.update(
                content: trimmed,
                deadline: deadline,
                priority: priority.rawValue,
                for: task
            )
        } else {
            taskService.createTaskWith(
                content: trimmed,
                deadline: deadline,
                priority: priority.rawValue
            )
        }
    }
    
}
