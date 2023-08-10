import SwiftUI
import CoreData

class TodoListViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    @Published var fetchedItems: [TodoPersistenceModel] = []
    @Published var isShowingSheet: Bool = false
    @Published var selectedTodoModel: TodoModel? = nil
    
    
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
    
    var futureTodoModels: [Binding<TodoModel>] {
        return todoModels.filter { $0.wrappedValue.dueDate > Date() }
    }

    var todayTodoModels: [Binding<TodoModel>] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return todoModels.filter { calendar.isDate($0.wrappedValue.dueDate, inSameDayAs: today) }
    }

    var pastTodoModels: [Binding<TodoModel>] {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        return todoModels.filter {
            $0.wrappedValue.dueDate < yesterday &&
            !calendar.isDate($0.wrappedValue.dueDate, inSameDayAs: calendar.startOfDay(for: Date()))
        }
    }
    
    private func updateTodo(at index: Int, with newValue: TodoModel) {
        withAnimation {
            let originalData = fetchedItems[index]
            originalData.title = newValue.title
            originalData.content = newValue.content
            originalData.dueDate = newValue.dueDate
            originalData.modifiedAt = newValue.modifiedAt
            originalData.isFinished = newValue.isFinished
            
            save()
        }
    }
    
    func addItem(from model: TodoModel) {
        withAnimation {
            let newItem = TodoPersistenceModel(context: viewContext)
            newItem.id = UUID()
            newItem.title = model.title
            newItem.content = model.content
            newItem.createdAt = model.createdAt
            newItem.dueDate = model.dueDate
            newItem.isFinished = model.isFinished
            save()
        }
    }
    
    
    func updateSelectedTodoModel() {
        if let selectedModel = selectedTodoModel, let itemIndex = fetchedItems.firstIndex(where: { $0.id == selectedModel.id }) {
            updateTodo(at: itemIndex, with: selectedModel)
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
