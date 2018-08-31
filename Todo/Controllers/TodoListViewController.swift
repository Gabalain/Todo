//
//  ViewController.swift
//  Todo
//
//  Created by Alain Gabellier on 27/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController { // UISearchBarDelegate in extension bellow
    
    // Realm Init for the second time, so try! is possible
    let realm = try! Realm()
    
    // Category selected
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // Set toDoList as array of Item defined in Core Data Entities
    var toDoList: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: DataSource Methods for Table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = toDoList?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items created yet"
            cell.accessoryType = .none
        }
        return cell
    }

    //MARK: Delegate Methods for Table view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Change the done property to the opposite.
        if let item = toDoList?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving Done status : \(error)")
            }
        }
        
        tableView.reloadData()

    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Action once user pressed Ok button
    
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.creationDate = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving Item \(error)")
                }
            }

            self.tableView.reloadData()
        }
        
        // Add TextField, Action (button) and then Show Alert
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Core Data
    func loadItems() {
        
        toDoList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}

//MARK: Search Bar methods
extension ToDoTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoList = toDoList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "creationDate", ascending: true)
        tableView.reloadData()   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            
            // remove keyboard and cursor in text field
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

