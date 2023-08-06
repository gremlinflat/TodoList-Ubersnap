//
//  Todo.swift
//  Todo List
//
//  Created by Fahri Novaldi on 06/08/23.
//

import Foundation

struct TodoModel: Identifiable {
    var id: UUID
    var title: String
    var content: String
    let createdAt: Date
    var modifiedAt: Date?
    var isFinished: Bool
    var dueDate: Date
    
    init(title: String = "Untitled", content: String = "", createdAt: Date = Date(), modifiedAt: Date? = nil, isFinished: Bool = false, dueDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.isFinished = isFinished
        self.dueDate = dueDate
    }
    
    init(from persistenceModel: TodoPersistenceModel) {
        self.id = persistenceModel.id!
        self.title = persistenceModel.title ?? "Untitled"
        self.content = persistenceModel.content ?? " "
        self.createdAt = persistenceModel.createdAt ?? Date()
        self.modifiedAt = persistenceModel.modifiedAt
        self.isFinished = persistenceModel.isFinished
        self.dueDate = persistenceModel.dueDate ?? Date()
    }
    
}


extension TodoModel {
    static let mock: [TodoModel] = [
        .init(title: "Do Laundry", content: "do laundry at jojo's houses", dueDate: .now),
        .init(title: "Finish Take home test", content: "Take Home test from Ubersnap", isFinished: true, dueDate: .now),
        .init(title: "Lunch with Ryan", content: "Luch with Ryan at McD", dueDate: .now),
        
    ]
}
