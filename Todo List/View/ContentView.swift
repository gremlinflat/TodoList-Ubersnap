//
//  ContentView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 04/08/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = TodoListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.todoModels, id: \.id) { item in
                TodoItemCellView(model: item, onDeleteAction: viewModel.deleteItem)
            }
            .transition(.slide)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Text("\(viewModel.todoModels.isEmpty ? "No" : "\(viewModel.todoModels.count)") items").animation(.smooth)
                    Spacer()
                    Button(action: viewModel.addItem) {
                        Image(systemName: "square.and.pencil")
                    }
                    .padding(.trailing, 15)
                }
            }.navigationTitle(Text("Todo"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
