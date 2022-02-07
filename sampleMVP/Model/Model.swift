//
//  Model.swift
//  sampleMVP
//
//  Created by 手塚友健 on 2022/02/06.
//

import Foundation

protocol ModelInput {
    func getTodo(completion: @escaping ([Todo]) -> Void)
    func addTodo(todo: Todo, completion: @escaping ([Todo]) -> Void)
    func deleteTodo(todo: Todo, completion: @escaping ([Todo]) -> Void)
}

// MARK: -- Model
final class Model: ModelInput {
    
    private let key = "todo"
    
    func getTodo(completion: @escaping ([Todo]) -> Void) {
        completion(getTodoList())
    }
    
    func addTodo(todo: Todo, completion: @escaping ([Todo]) -> Void) {
        var todoList = getTodoList()
        todoList.append(todo)
        saveTodoList(todo: todoList)
        completion(todoList)
    }
    
    func deleteTodo(todo: Todo, completion: @escaping ([Todo]) -> Void) {
        let todoList = getTodoList()
        let newTodoList = todoList.filter { $0.id != todo.id }
        saveTodoList(todo: newTodoList)
        completion(newTodoList)
    }
    private func getTodoList() -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        guard let array = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Todo]
        else {
            return []
        }
        return array
    }
    private func saveTodoList(todo: [Todo]) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: todo,
                                                           requiringSecureCoding: false)
        else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
