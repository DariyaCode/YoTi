//
//  CategoryViewController.swift
//  YoTi
//
//  Created by Dariya Gecher on 02.04.2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //loading the data of my categories
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    func saveCategory() {
        //Im saving the list of items to (NSObject) -> context and those data into my array
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //Im loading saved items to (NSObject) -> context and requesting this data for forward it to my table, so because of this it will be visable for user
        do{
            categories = try context.fetch(request)
        } catch{
            print("Error fatching data from context, \(error)")
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //creating the alert via text field for name of new item
        let alert = UIAlertController(title: "Add new YoTi Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategory()
        }
        //
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the count of item bucause i need follow the number, so the reason is to now which one item need to be marked
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        //
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveCategory()
    }
}
