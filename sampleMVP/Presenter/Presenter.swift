//
//  Presenter.swift
//  sampleMVP
//
//  Created by 手塚友健 on 2022/02/06.
//

import Foundation

protocol PresenterInput {
    var numberOfTodo: Int { get }
    func todo(forRow  row: Int)  -> Todo?
    func didTapAddButton(todoText: String?)
    func didTapTodoCell(at indexPath: IndexPath)
    func viewDidLoad()
}

protocol PresenterOutput: AnyObject {
    func todoValidation(validation: TodoValidation)
    func updateTodo()
}

// MARK: -- Presenter
final class Presenter: PresenterInput {
    
    private(set) var todoList: [Todo] = []
    
    var numberOfTodo: Int {
        return todoList.count
    }
    
    private weak var view: PresenterOutput!
    private var model: ModelInput
    
    init(view: PresenterOutput, model: ModelInput) {
        self.view = view
        self.model = model
    }
    
    func todo(forRow row: Int) -> Todo? {
        guard row < todoList.count else { return nil }
        return todoList[row]
    }
    
    func viewDidLoad() {
        model.getTodo() { todoList in
            self.todoList = todoList
            self.view.updateTodo()
        }
    }
    
    func didTapAddButton(todoText: String?) {
        // 空白バリデーション
        guard !(todoText ?? "").isEmpty else {
            self.view.todoValidation(validation: .blank)
            return
        }
        
        // 文字数バリデーション
        if todoText!.count > 20 {
            self.view.todoValidation(validation: .overMaximumCharacters)
            return
        }
        
        // todoを保存
        let todo = Todo(todo: todoText!)
        self.model.addTodo(todo: todo) { todoList in
            // 保存した後の処理
            self.todoList = todoList
            self.view.updateTodo()
        }
    }
    
    func didTapTodoCell(at indexPath: IndexPath) {
        let deleteTodo = self.todoList[indexPath.row]
        model.deleteTodo(todo: deleteTodo) { todoList in
            // 削除した後の処理
            self.todoList = todoList
            self.view.updateTodo()
        }
    }
}
