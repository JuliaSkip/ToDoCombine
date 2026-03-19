//
//  TaskFormView.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 26.02.2026.
//

import SwiftUI

struct TaskFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel: TaskFormViewModel
    
    let title: String
    let buttonTitle: String
    let buttonWidth: CGFloat
    
    init(
        taskService: CDTaskService,
        taskToEdit: Task? = nil,
        title: String,
        buttonTitle: String,
        buttonWidth: CGFloat = 160
    ) {
        _viewModel = StateObject(wrappedValue: TaskFormViewModel(taskService: taskService, taskToEdit: taskToEdit))
        self.title = title
        self.buttonTitle = buttonTitle
        self.buttonWidth = buttonWidth
    }
    
    var body: some View {
        VStack {
            makeTaskContentTextField()
            makeDeadlinePicker()
            makePrioritySelect()
            makeSaveButton()
            
            Spacer()
        }
        .navigationTitle(title)
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    @ViewBuilder
    private func makeTaskContentTextField() -> some View {
        TextField("Task content...", text: $viewModel.text)
            .padding(10)
            .focused($isTextFieldFocused)
            .onSubmit { isTextFieldFocused = false }
            .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
            .padding()
    }
    
    private func makePrioritySelect() -> some View {
        Picker("Priority", selection: $viewModel.priority) {
            Text("Low").tag(Priority.low)
            Text("Medium").tag(Priority.medium)
            Text("High").tag(Priority.high)
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    @ViewBuilder
    private func makeDeadlinePicker() -> some View {
        DatePicker("Deadline: ",
                   selection: Binding<Date>(
                    get: { viewModel.deadline ?? .now },
                    set: { viewModel.deadline = $0 }
                   )
        )
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 15).stroke(style: StrokeStyle(lineWidth: 1)))
        .padding()
    }
    
    private func makeSaveButton() -> some View {
        Button {
            viewModel.save()
            dismiss()
        } label: {
            Text(buttonTitle).frame(maxWidth: .infinity)
        }
        .frame(width: buttonWidth)
        .buttonStyle(.glass)
        .background(RoundedRectangle(cornerRadius: 30).fill(Color(red: 1.0, green: 0.79, blue: 0.83)))
        .disabled(!viewModel.isSaveEnabled)
        .padding(.horizontal)
    }
}

