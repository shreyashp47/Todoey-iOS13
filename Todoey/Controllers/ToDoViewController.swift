//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
     
    let dataFinePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    //var itemArray = ["Milk" , "Oil" , "Mac"]
    var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        
        loadItems(with: Item.fetchRequest())
        
        
        //        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        
    }
    
    
    //MARK: - DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    
    
    
    
    //MARK: - Tableview delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        //to delete from database
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        //--
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems()
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle:  .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            if let text = textField.text {
                
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                self.itemArray.append(newItem)
                
                //self.defaults.set(self.itemArray,forKey: "ToDoListArray")
                //let encoder = PropertyListEncoder()
                
                self.saveItems()
                
            }
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    
    func saveItems(){
        do {
            
            try context.save()
        }catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
    
    func loadItems(with request: NSFetchRequest<Item>) {
        
        //        if  let data = try? Data(contentsOf: dataFinePath!){
        //            let decoder = PropertyListDecoder()
        //            do {
        //                itemArray = try decoder.decode([Item].self, from: data)
        //            } catch {
        //                print("error")
        //            }
        //
        //        }
        
        
        //fetching data from database // core data
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray =   try context.fetch(request)
        }catch {
            print("error - \(error)")
        }
        tableView.reloadData()
    }
    
    
}



//MARK: - Searchbar methods
extension ToDoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
         
        
    
        loadItems(with: request)
        
    }
   
}
