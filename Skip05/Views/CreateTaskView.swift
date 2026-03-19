//
//  CreateTaskView.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import SwiftUI

struct CreateTaskView: View {
    
    let taskService: CDTaskService
    
    var body: some View {
        TaskFormView(
            taskService: taskService,
            title: "Add new task",
            buttonTitle: "Add Task",
            buttonWidth: 100
        )
    }
    
}
