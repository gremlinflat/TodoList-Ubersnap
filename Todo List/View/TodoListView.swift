//
//  TodoListView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 04/08/23.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject private var viewModel = TodoListViewModel()
    
    func onCellTap(for model: TodoModel ) {
        viewModel.selectedTodoModel = model
        viewModel.isShowingSheet.toggle()
    }
    
    var body: some View {
        NavigationView {
            if viewModel.todoModels.isEmpty {
                Button("Add To-do", action: {
                    viewModel.isShowingSheet.toggle()
                })
                    .navigationTitle(Text("Ubersnap To-Do"))
            } else {
                List {
                    if !viewModel.futureTodoModels.isEmpty {
                        Section(header: Text("Future")) {
                            ForEach(viewModel.futureTodoModels, id: \.id) { item in
                                TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem) {
                                    onCellTap(for: item.wrappedValue)
                                }
                            }
                        }
                    }
                    if !viewModel.todayTodoModels.isEmpty {
                        Section(header: Text("Today")) {
                            ForEach(viewModel.todayTodoModels, id: \.id) { item in
                                TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem) {
                                    onCellTap(for: item.wrappedValue)
                                }
                            }
                        }
                    }
                    if !viewModel.pastTodoModels.isEmpty {
                        Section(header: Text("Past")) {
                            ForEach(viewModel.pastTodoModels, id: \.id) { item in
                                TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem){
                                    onCellTap(for: item.wrappedValue)
                                }
                            }
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
            }
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
