//
//  Todo_ListApp.swift
//  Todo List
//
//  Created by Fahri Novaldi on 04/08/23.
//

import SwiftUI

@main
struct Todo_ListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
    }
}
