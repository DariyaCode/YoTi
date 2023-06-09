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
        
        
        //loading the data of my categories for list
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the count of item bucause i need follow the number, so the reason is to now which one item need to be marked
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //initialaze the screen & creating the safe plase for saving the data of every category
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        //saving the labels of categories in list of them
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delegate methods, send the direction from category to items
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        //We must be sure of the correctness of the choice of a particular category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //creating the alert via text field for name of new item
        let alert = UIAlertController(title: "Add new YoTi Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //initialize the categories for list of items
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
                //appending the new for list data for category
            self.categories.append(newCategory)
            self.saveCategory()
        }
        //Now we see the text field were need to name the element category of the list
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        //Im saving the list of items to (NSObject) -> context and those data into my array
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    func loadCategory() {
        //Im loading saved items to (NSObject) -> context and requesting this data for forward it to my table, so because of this it will be visable for user
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        } catch{
            print("Error fatching data from context, \(error)")
        }
        tableView.reloadData()
    }
    

}
