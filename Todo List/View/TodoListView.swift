//
//  TodoListView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 04/08/23.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject private var viewModel = TodoListViewModel()
    
    
    var body: some View {
        NavigationView {
//            List(viewModel.todoModels, id: \.id) { item in
//                TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem)
//                    .onTapGesture(perform: {
//                        viewModel.selectedTodoModel = item.wrappedValue
//                        viewModel.isShowingSheet.toggle()
//                    })
            List {
                Section(header: Text("Future")) {
                    ForEach(viewModel.futureTodoModels, id: \.id) { item in
                        TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem)
                            .onTapGesture(perform: {
                                viewModel.selectedTodoModel = item.wrappedValue
                                viewModel.isShowingSheet.toggle()
                            })
                    }
                }
                Section(header: Text("Today")) {
                    ForEach(viewModel.todayTodoModels, id: \.id) { item in
                        TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem)
                            .onTapGesture(perform: {
                                viewModel.selectedTodoModel = item.wrappedValue
                                viewModel.isShowingSheet.toggle()
                            })
                    }
                }
                Section(header: Text("Past")) {
                    ForEach(viewModel.pastTodoModels, id: \.id) { item in
                        TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem)
                            .onTapGesture(perform: {
                                viewModel.selectedTodoModel = item.wrappedValue
                                viewModel.isShowingSheet.toggle()
                            })
                    }
                }
            }
            .transition(.slide)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Text("\(viewModel.todoModels.isEmpty ? "No" : "\(viewModel.todoModels.count)") items").animation(.smooth)
                    Spacer()
                    Button(action: {
                        viewModel.isShowingSheet.toggle()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    .padding(.trailing, 15)
                }
            }.navigationTitle(Text("Ubersnap To-Do"))
        }.sheet(isPresented: $viewModel.isShowingSheet) {
            AddTodoItemView(model: $viewModel.selectedTodoModel, onCreateAction: viewModel.addItem, onSaveAction: viewModel.updateSelectedTodoModel)
                .presentationDetents([.medium, .large])
                .onDisappear(perform: {
                    viewModel.selectedTodoModel = nil
                })
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
