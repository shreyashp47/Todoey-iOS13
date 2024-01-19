//
//  CategoryTableViewCell.swift
//  Todoey
//
//  Created by Shreyash Pattewar on 07/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems(with: Category.fetchRequest())
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategroyCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ToDoViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category Item", message: "", preferredStyle:  .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){
            (action) in
            if let text = textField.text {
                
                let newItem = Category(context: self.context)
                newItem.name = text
                self.categoryArray.append(newItem)
                self.saveCategories()
                
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
    }
    
    func saveCategories(){
        do {
            
            try context.save()
        }catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category>) {
        

        do {
            
            
            categoryArray =   try context.fetch(request)
        }catch {
            print("error - \(error)")
        }
        tableView.reloadData()
    }

    
}
