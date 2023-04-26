//
//  ViewController.swift
//  YoTi
//
//  Created by Dariya Gecher on 16.03.2023.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            //loading the data of my items
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //commenting the Directory for my experiments
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the count of item bucause i need follow the number, so the reason is to now which one item need to be marked
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        //
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //creating the alert via text field for name of new item
        let alert = UIAlertController(title: "Add new YoTi Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        //
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        //Im saving the list of items to (NSObject) -> context and those data into my array
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //Im loading saved items to (NSObject) -> context and requesting this data for forward it to my table, so because of this it will be visable for user
        let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("Error fatching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - SearchBar Manupulation Methods

extension TodoListViewController: UISearchBarDelegate {
    
    //function where search bar is creating & it giving the results of searching. List of items, that corresponds to the search condition
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //after creating the fetching request, assign to the variable searchText the search bar's text and adding the format of predicate what i need of my search condition(searching elements by them titles)
//
//        if let searchText = searchBar.text {
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//        }
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sorting the items by format of them titles & loading the searching items list also reload the table, so to update the data of list
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    //function that return the ordinary list of items, when the search bar's text is empty
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //after adding the condition, i sending the results
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            //loading the ordinary items list also reload the table, so to update the data of list
            loadItems()
            tableView.reloadData()
        }
    }
}

