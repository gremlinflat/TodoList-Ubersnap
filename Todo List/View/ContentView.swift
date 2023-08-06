//
//  ContentView.swift
//  Todo List
//
//  Created by Fahri Novaldi on 04/08/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TodoPersistenceModel.isFinished, ascending: true)],
        animation: .smooth)
    
    private var fetchedItems: FetchedResults<TodoPersistenceModel>
    private var todoModels: [Binding<TodoModel>] {
        fetchedItems.indices.map { index in
            Binding(
                get: { TodoModel(from: fetchedItems[index]) },
                set: { newValue in
                    withAnimation {
                        // Update your CoreData model here
                        let originalData = fetchedItems[index]
                        originalData.title = newValue.title
                        originalData.content = newValue.content
                        originalData.dueDate = newValue.dueDate
                        originalData.modifiedAt = Date()
                        originalData.isFinished = newValue.isFinished
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
            )
        }
    }
    var body: some View {
        NavigationView {
            List(todoModels, id: \.id) { item in
                TodoItemCellView(model: item)
            }
            .transition(.slide)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Text("\(todoModels.count) items").animation(.smooth)
                    Spacer()
                    Button(action: addItem) {
                        Image(systemName: "square.and.pencil")
                    }
                    .padding(.trailing, 15)
                }
            }.navigationTitle(Text("Todo"))
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = TodoPersistenceModel(context: viewContext)
            newItem.id = UUID()
            newItem.createdAt = Date()
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            newItem.title = String((0..<5).map { _ in characters.randomElement()! })
            
            newItem.content = String((0..<18).map { _ in characters.randomElement()! })
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fetchedItems[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
