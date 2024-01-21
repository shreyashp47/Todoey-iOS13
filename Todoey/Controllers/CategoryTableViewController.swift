//
//  CategoryTableViewCell.swift
//  Todoey
//
//  Created by Shreyash Pattewar on 07/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
        
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategroyCell",
            for: indexPath
        ) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        return cell
    }
    
    
    
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        performSegue(
            withIdentifier: "goToItems",
            sender: self
        )
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        let destination = segue.destination as! ToDoViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(
        _ sender: UIBarButtonItem
    ) {
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add new Category Item",
            message: "",
            preferredStyle:  .alert
        )
        
        let action = UIAlertAction(
            title: "Add Category",
            style: .default
        ){
            (
                action
            ) in
            if let text = textField.text {
                
                let newCategory = Category()
                newCategory.name = text
                self.save(
                    category: newCategory
                )
                
            }
        }
        alert.addTextField{ (
            alertTextField
        ) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        
        alert.addAction(
            action
        )
        present(
            alert,
            animated: true,
            completion: nil
        )
        
    }
    
    func save(
        category: Category
    ){
        do {
            // to write in realm database
            try realm.write{
                realm.add(
                    category
                )
            }
        }catch {
            print(
                error
            )
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(
            Category.self
        )
        
        tableView.reloadData()
        
      

    }
    
    
}

//MARK: - SwipeTableViewCellDelegate
extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
    ) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        
        let deleteAction = SwipeAction(
            style: .destructive,
            title: "Delete"
        ) {
            action,
            indexPath in
            // handle action by updating model with deletion
            
            if let deletion = self.categoryArray?[indexPath.row]{
                do {
                    try self.realm.write {
                        self.realm.delete(
                            deletion
                        )
                    }}
                catch{
                    
                }
            }
            //tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(
            named: "delete"
        )
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
}
