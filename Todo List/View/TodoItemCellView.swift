//
//  TodoItemCellView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 06/08/23.
//

import SwiftUI

struct TodoItemCellView: View {
    @Binding var model: TodoModel
    
    var onDeleteAction: ((UUID) -> Void)?
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 15) {
                Button {
                    model.isFinished.toggle()
                } label: {
                    Image(systemName: model.isFinished ? "record.circle" : "circle")
                        .font(.title)
                        .foregroundColor(model.isFinished ? .gray : .accentColor)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(model.title)
                        .font(.headline)
                        .strikethrough(model.isFinished, color: .gray)
                    Text(model.content)
                        .font(.caption)
                        .strikethrough(model.isFinished, color: .gray)
                }
                .if(model.isFinished) { view in
                    view.foregroundColor(.gray)
                }
            }
        }.swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                toggleItem()
            } label: {
                Text(model.isFinished ? "Undone" : "Done")
            }.if(model.isFinished) { view in
                view.tint(.red)
            } else: { view in
                view.tint(.green)
            }
        }.swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                (onDeleteAction?(model.id) ?? {}())
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    private func toggleItem() {
        model.isFinished.toggle()
    }
}

struct TodoItemCellView_Previews: PreviewProvider {
    @State static var todoModel1 = TodoModel.mock[0]
    @State static var todoModel2 = TodoModel.mock[1]
    
    static var previews: some View {
        VStack {
            TodoItemCellView(model: $todoModel1) // Use $ to create a binding
            TodoItemCellView(model: $todoModel2)
        }
    }
}

