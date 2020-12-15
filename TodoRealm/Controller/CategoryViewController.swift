//
//  ViewController.swift
//  TodoRealm
//
//  Created by Łukasz Rajczewski on 13/12/2020.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        // navBarAppearance for setting color when title is large
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemTeal
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
    }
    
    // MARK: - Save categories
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch let err as NSError {
            print("Error saving new category: \(err)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Load categories
    func load() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }


    // MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (save) in
                        
            if let text = textField.text {
                if text.count > 1 {
                    let newCategory = Category()
                    newCategory.name = text
                    self.save(newCategory)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! ItemViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

