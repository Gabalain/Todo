//
//  ViewController.swift
//  Todo
//
//  Created by Alain Gabellier on 27/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var toDoList = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add items to the List
//        let newItem = Item()
//        newItem.title = "First Item"
//        newItem.done = false
//        toDoList.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Second Item"
//        newItem2.done = true
//        toDoList.append(newItem2)
        
        // Used for UserDefaults storage
//        guard let List = defaults.value(forKey: "ToDoListArray") else { return }
//        toDoList = List as! [String]
        
        // Load Items from pList
        loadItems()
    }

    //MARK: DataSource Methods for Table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoList[indexPath.row].title
        cell.accessoryType = toDoList[indexPath.row].done ? .checkmark : .none
        return cell
    }

    //MARK: Delegate Methods for Table view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoList[indexPath.row].done = !toDoList[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Nouveau To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Action once user pressed Ok button
            let new = Item()
            new.title = textField.text!
            self.toDoList.append(new)
            
            // Encode data for pList
            self.saveItems()
 
        }
        
        // Add TextField, Action (button) and then Show Alert
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Nouveau To Do"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        // Encode data for pList
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(toDoList)
            try data.write(to: dataFilePath!)
        } catch {
            print("Encoding failed ! : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        // Encode data for pList
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            toDoList = try decoder.decode([Item].self, from: data)
        } catch {
            print("Loading data failed ! : \(error)")
        }
        tableView.reloadData()
    }
    
}

