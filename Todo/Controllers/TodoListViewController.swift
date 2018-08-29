//
//  ViewController.swift
//  Todo
//
//  Created by Alain Gabellier on 27/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController { // UISearchBarDelegate in extension bellow
    
    // Category selected
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // Set toDoList as array of Item defined in Core Data Entities
    var toDoList = [Item]()
    
    // Access to the persistent container of the App Delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Delete the clicked Cell
        // Attention à l'ordre des actions pour gerer les index
//        context.delete(toDoList[indexPath.row])
//        toDoList.remove(at: indexPath.row)
        
        
        // Change the done property to the opposite.
        toDoList[indexPath.row].done = !toDoList[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New To Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Action once user pressed Ok button
    
            // Set newItem for CoreData (context)
            let newItem = Item(context: self.context)
            // Set default values for this newItem
            newItem.title = textField.text!
            newItem.done = false
            newItem.category = self.selectedCategory
            // Append to toDoList
            self.toDoList.append(newItem)
            // Save to DB
            self.saveItems()
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

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
        // add predicate to grab only Items of selected Category
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            request.predicate = compound
        } else {
            request.predicate = categoryPredicate
        }

        do {
            toDoList = try context.fetch(request)
        } catch {
            print("Data fetch failed \(error)")
        }
        tableView.reloadData()
    }

}

//MARK: Search Bar methods
extension ToDoTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Create request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(request)
        // Create predicate (query)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // [cd] = non sensitive to case & diacritic
        // add the predicate (query) to the request
//        request.predicate = predicate
        // Create sort
        let sort = NSSortDescriptor(key: "title", ascending: true)
        // add sort to the request
        request.sortDescriptors = [sort]
        
        // Launch request
        loadItems(with: request, and: predicate)
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

