//
//  ItemViewController.swift
//  TodoRealm
//
//  Created by Łukasz Rajczewski on 15/12/2020.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            load()
        }
    }
    
    func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "title")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (save) in
            
            if let currentCategory = self.selectedCategory {
                
                if let text = textField.text {
                    
                    if text.count > 1 {
                        do {
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = text
                                
                                currentCategory.items.append(newItem)
                            }
                        } catch {
                            print("Error adding new item: \(error)")
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item title"
            textField = alertTextField
        }
        
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = items?[indexPath.row].title ?? "No items added"
        
        cell.accessoryType = items?[indexPath.row].done == true ? .checkmark : .none
        
        return cell 
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error: \(error)")
            }
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //         MARK: - Swipe to delete row
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (delete, view, handler) in
            
            
            if let itemToDelte = self.items?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(itemToDelte)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error deleting item: \(error)")
                }
            }
            
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

