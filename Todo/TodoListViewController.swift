//
//  ViewController.swift
//  Todo
//
//  Created by Alain Gabellier on 27/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    var toDoList = ["Do this", "Do that", "Et la suite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let List = defaults.value(forKey: "ToDoListArray") else { return }
        toDoList = List as! [String]
    }

    //MARK: DataSource Methods for Table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = toDoList[indexPath.row]
        return cell
    }

    //MARK: Delegate Methods for Table view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.tintColor = UIColor(red: 215/255, green: 152/255, blue: 64/255, alpha: 1)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Nouveau To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Action once user pressed Ok button
            self.toDoList.append(textField.text!)
            self.tableView.reloadData()
            self.defaults.set(self.toDoList, forKey: "ToDoListArray")
        }
        
        // Add TextField, Action (button) and then Show Alert
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Nouveau To Do"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

