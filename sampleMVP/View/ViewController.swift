//
//  ViewController.swift
//  sampleMVP
//
//  Created by 手塚友健 on 2022/02/06.
//

import UIKit

// MARK: -- View
class ViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: PresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.presenter = Presenter(view: self, model: Model())
        presenter.viewDidLoad()
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        presenter.didTapAddButton(todoText: textField.text)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTodo
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = presenter.todo(forRow: indexPath.row)?.todo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todo = presenter.todo(forRow: indexPath.row) else {
            return
        }
        let alert = UIAlertController(title: "『\(todo.todo)』を削除します。よろしいですか？", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // OKボタン
            self.presenter.didTapTodoCell(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}


extension ViewController: PresenterOutput {
    
    func updateTodo() {
        textField.text = ""
        tableView.reloadData()
    }
    
    func todoValidation(validation: TodoValidation) {
        self.textField.text = ""
        let alert = UIAlertController(title: validation.alert, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
