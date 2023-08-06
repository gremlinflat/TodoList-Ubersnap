import SwiftUI
import CoreData

class TodoListViewModel: ObservableObject {
//    @Environment(\.managedObjectContext) private var viewContext
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    @Published var fetchedItems: [TodoPersistenceModel] = []

    init() {
        fetchItems()
    }

    private func fetchItems() {
        do {
            let fetchRequest: NSFetchRequest<TodoPersistenceModel> = TodoPersistenceModel.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TodoPersistenceModel.isFinished, ascending: true)]
            fetchedItems = try viewContext.fetch(fetchRequest)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    var todoModels: [Binding<TodoModel>] {
        fetchedItems.indices.map { index in
            Binding(
                get: { TodoModel(from: self.fetchedItems[index]) },
                set: { newValue in
                    self.updateTodo(at: index, with: newValue)
                }
            )
        }
    }

    private func updateTodo(at index: Int, with newValue: TodoModel) {
        withAnimation {
            let originalData = fetchedItems[index]
            originalData.title = newValue.title
            originalData.content = newValue.content
            originalData.dueDate = newValue.dueDate
            originalData.modifiedAt = Date()
            originalData.isFinished = newValue.isFinished

            save()
        }
    }

    func addItem() {
        withAnimation {
            let newItem = TodoPersistenceModel(context: viewContext)
            newItem.id = UUID()
            newItem.createdAt = Date()
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            newItem.title = String((0..<5).map { _ in characters.randomElement()! })
            newItem.content = String((0..<18).map { _ in characters.randomElement()! })

            save()
        }
    }

    private func save() {
        do {
            try viewContext.save()
            fetchItems() // Update fetchedItems after saving changes
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteItem(for id: UUID) -> Void {
            withAnimation {
                let itemToDelete = fetchedItems.filter { $0.id! == id }
                guard let item = itemToDelete.first else { return }
                viewContext.delete(item)
                
                save()
            }
        }
}
