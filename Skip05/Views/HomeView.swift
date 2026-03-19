//
//  HomeView.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 20.02.2026.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    private var taskService: CDTaskService
    @StateObject private var taskVM: TasksViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init(service : CDTaskService) {
        self.taskService = service
        _taskVM = StateObject(wrappedValue: TasksViewModel(taskService: service))
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                makeSearchField()
                makeSortMenu()
                
                ScrollView{
                    LazyVStack(spacing: 20){
                        ForEach(taskVM.tasks, id: \.objectID) { task in
                            makeComponent(for: task)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .navigationTitle("Your tasks")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CreateTaskView(taskService: taskService)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
            }
            
        }
        .contentShape(Rectangle())
        .onTapGesture { isTextFieldFocused = false }
    }
    
    
    @ViewBuilder
    func makeSearchField() -> some View {
        TextField("Search tasks by name...", text: $taskVM.filterText)
        .focused($isTextFieldFocused)
        .onSubmit { isTextFieldFocused = false}
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
        .padding()
    }
    
    @ViewBuilder
    func makeSortMenu() -> some View {
        HStack {
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button { taskVM.sortOption = option }
                    label: {
                        Label { Text("Sort by \(option.rawValue)") }
                        icon: { if taskVM.sortOption == option { Image(systemName: "checkmark") } }
                    }
                }
            }
            label: { Label { Text("Sorted by \(taskVM.sortOption.rawValue)") } icon: {} }
                .frame(width: 200)
                .compositingGroup()
                .buttonStyle(.glass)
            Spacer()
        }
    }
    
    @ViewBuilder
    func makeComponent(for task: Task) -> some View {
        NavigationLink {
            EditTaskView(task: task, taskService: taskService)
        } label: {
            HStack{
                VStack (alignment: .leading){
                    makeContentCard(for: task)
                    makeDeleteButton(for: task)
                }
                Spacer()
                makeToggle(for: task)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 30).fill( getColor(for: task)))
        }
    }
    
    @ViewBuilder
    func makeContentCard(for task: Task) -> some View {
        HStack{
            VStack(alignment: .leading){
                Text(task.content ?? "")
                    .padding()
                    .font(.title)
                
                if let date = task.deadline {
                    HStack{
                        Text(date, style: .date)
                            .font(.system(size: 15, weight: .regular, design: .default))
                        
                        Text(date, style: .time)
                            .font(.system(size: 15, weight: .regular, design: .default))
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func makeDeleteButton(for task: Task) -> some View {
        HStack{
            Button(
                action : { taskVM.delete(task) },
                label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            )
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func makeToggle(for task: Task) -> some View {
        Toggle( "", isOn: Binding<Bool>(
            get: { task.isDone },
            set: { _ in taskVM.updateStatus(for: task)}
        ))
        .toggleStyle(iOSCheckboxToggleStyle())
    }
    
    
    func getColor(for task: Task) -> Color {
        if task.isDone { return Color(red: 217/255, green: 217/255, blue: 217/255).opacity(0.5) }
        else {
            switch task.priority {
            case Priority.high.rawValue: return Color(red: 216/255, green: 140/255, blue: 154/255).opacity(0.5)
            case Priority.medium.rawValue: return Color(red: 242/255, green: 208/255, blue: 169/255).opacity(0.5)
            case Priority.low.rawValue: return Color(red: 189/255, green: 234/255, blue: 184/255).opacity(0.5)
            default: return Color.clear
            }
        }
    }
}

