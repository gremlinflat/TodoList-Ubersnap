//
//  AddTodoItemView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 06/08/23.
//

import SwiftUI

struct AddTodoItemView: View {
    //    @ObservedObject var viewModel: TodoListViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var dueDate = Date()
    @State private var isFinished = false
    private var dateNow = Date()
    
    let onCreateAction: ((TodoModel) -> Void)?
    let onSaveAction: (() -> Void)?
//    private var model: Binding<TodoModel?>?
    @Binding private var model: TodoModel?
    
    init(model: Binding<TodoModel?>? = nil, onCreateAction: ((TodoModel) -> Void)? = nil, onSaveAction: (() -> Void)? = nil ) {
        self._model = model ?? .constant(nil)
        self.onCreateAction = onCreateAction
        self.onSaveAction = onSaveAction
        
        _title = State(initialValue: model?.wrappedValue?.title ?? "")
        _content = State(initialValue: model?.wrappedValue?.content ?? "")
        _dueDate = State(initialValue: model?.wrappedValue?.dueDate ?? Date())
        _isFinished = State(initialValue: model?.wrappedValue?.isFinished ?? false)
    }
    
    var body: some View {
        VStack {
            Text("Created at \(formatDate(model?.createdAt ?? dateNow))")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .background(ignoresSafeAreaEdges: .all)
            
            if (((model?.modifiedAt) != nil)) {
                Text("Last Modified at \(formatDate(model?.modifiedAt))")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .background(ignoresSafeAreaEdges: .all)
            }
            
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title, prompt: Text("Write Todo Title Here"))
                    
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $content, prompt: Text("Description about the task"), axis: .vertical)
                }
                Section {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
                Section(header: Text("Status")) {
                    Toggle("Finished", isOn: $isFinished)
                }
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }.tint(.red)
                    Spacer()
                    Button((model == nil) ? "Add" : "Save") {
                        if (model == nil) {
                            let newItem = TodoModel(title: title.isEmpty ? "Untitled" : title, content: content.isEmpty ? "Description" : content, createdAt: dateNow, modifiedAt: dateNow, isFinished: isFinished, dueDate: dueDate)
                            onCreateAction?(newItem)
                        } else {
                            // Update the entire model object
                            model?.title = title
                            model?.content = content
                            model?.dueDate = dueDate
                            model?.isFinished = isFinished
                            model?.modifiedAt = dateNow
                            onSaveAction?()
                        }
                    }
                }
            }
        }
    }
}

extension AddTodoItemView {
    private func formatDate(_ date: Date?) -> String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


struct AddTodoItemView_Previews: PreviewProvider {
    @State static var showingCredits = false
    static var previews: some View {
        AddTodoItemView()
    }
}
