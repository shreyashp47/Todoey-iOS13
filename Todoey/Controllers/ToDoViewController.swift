//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //loadItems(with: Item.fetchRequest())
        
        
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        
    }
    
    
    //MARK: - DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if  let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else
        {
            cell.textLabel?.text = "No items added"
        }
        
        
        
        return cell
    }
    
    
    
    
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if let item = toDoItems?[indexPath.row] {
            do{ try realm.write
                {
                    item.done = !item.done
                    
                    
                    //to delete item from database
                    //realm.delete(item)
                    
                }
            }catch {
                print("didSelectRowAt \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle:  .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            if let text = textField.text {
                if let currentCategory = self.selectedCategory {
                    do {
                        
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch{
                        
                    }
                }
                self.tableView.reloadData()
                
                
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    
    func saveItems(item : Item){
        
        //        do {
        //
        //            try context.save()
        //        }catch {
        //            print(error)
        //        }
        //
        //        tableView.reloadData()
    }
    
    
    
    func loadItems() {
        
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        
        
        tableView.reloadData()
    }
    
    
}



//MARK: - Searchbar methods
extension ToDoViewController: UISearchBarDelegate {
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
            
        } else{
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        
        tableView.reloadData()
    }
    
}
