//
//  CategoryTableViewController.swift
//
//
//  Created by Alain Gabellier on 29/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    // Set categoriesList as array of Category defined in Core Data Entities
    var categoryList = [Category]()
    
    // Access to the persistent container of the App Delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show application Files path
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories() // By default, Category.fetchRequest() is replacing parameter if not specified
    }
    
    //MARK: DataSource Methods for Table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    //MARK: Delegate Methods for Table view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let itemsListVC = segue.destination as! ToDoTableViewController
            
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            itemsListVC.selectedCategory = categoryList[indexPath.row]
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
            let newCategory = Category(context: self.context)
            // Set default values for this newItem
            newCategory.name = textField.text!
            // Append to categoryList
            self.categoryList.append(newCategory)
            // Save to DB
            self.saveCategories()
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
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Data fetch failed \(error)")
        }
        tableView.reloadData()
    }

    
    //MARK: Tableview DataSource Methods
    
    //MARK: Tableview Delegate Methods
    
    //MARK: Data manipulation methods
}
