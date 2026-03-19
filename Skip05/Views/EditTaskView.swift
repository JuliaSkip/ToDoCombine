//
//  EditTaskView.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import SwiftUI

struct EditTaskView: View {
    
    let task: Task
    let taskService: CDTaskService

    var body: some View {
        TaskFormView(
            taskService: taskService,
            taskToEdit: task,
            title: "Edit task",
            buttonTitle: "Save Changes",
            buttonWidth: 200
        )
    }
    
}
