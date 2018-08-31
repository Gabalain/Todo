//
//  CategoryTableViewController.swift
//
//
//  Created by Alain Gabellier on 29/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    // Realm Init for the second time, so try! is possible
    let realm = try! Realm()
    
    // Set categoriesList as array of Category defined in Core Data Entities
    var categoryList: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show application Files path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories() // By default, Category.fetchRequest() is replacing parameter if not specified
    }
    
    //MARK: DataSource Methods for Table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No category added yet"
        return cell
    }
    
    //MARK: Delegate Methods for Table view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsListVC = segue.destination as! ToDoTableViewController
            
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            itemsListVC.selectedCategory = categoryList?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Perform Segue to go to Items
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            // Action once user pressed Ok button
            
            // Set newItem for CoreData (context)
            let newCategory = Category()
            // Set default values for this newItem
            newCategory.name = textField.text!
            // Append to categoryList
 //           self.categoryList.append(newCategory) // Automatically done in Realm Results data Types
            // Save to DB
            self.save(category: newCategory)
        }
        
        // Add TextField, Action (button) and then Show Alert
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New category name"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Core Data
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        // Fetch data from Realm DB
        categoryList = realm.objects(Category.self)
    
        tableView.reloadData()
    }
}
