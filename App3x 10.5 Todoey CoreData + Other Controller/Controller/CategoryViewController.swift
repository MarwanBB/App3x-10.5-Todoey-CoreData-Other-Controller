//
//  ViewController.swift
//  App3x 10.1 Todoey
//
//  Created by Marwan Elbahnasawy on 04/06/2022.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryEntity = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadCategories()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Todoey", message: "Add a new memo", preferredStyle: .alert)
        var alertTextField = UITextField()
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            if let safeAlertTextFieldText = alertTextField.text {
                
                let newCategory = Category(context: self.context)
                newCategory.titleCategory = safeAlertTextFieldText
                newCategory.dateCategory = Date().timeIntervalSince1970
                
                self.categoryEntity.append(newCategory)
                self.saveCategories()
            }
            
        }
        alert.addAction(alertAction)
        alert.addTextField { textField in
            textField.placeholder = "Memo Title"
            alertTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryEntity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = categoryEntity[indexPath.row].titleCategory
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        let indexPath = tableView.indexPathForSelectedRow
        destinationVC.selectedCategory = categoryEntity[indexPath!.row]
    }
    
    func loadCategories(){
        let request = Category.fetchRequest()
        let sortDesciptor = NSSortDescriptor(key: "dateCategory", ascending: false)
        request.sortDescriptors = [sortDesciptor]
        do {
        categoryEntity = try context.fetch(request)
    }
        catch {
            print("Error while trying to load Items ---> \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func saveCategories(){
        do {
        try context.save()
    }
        catch {
            print("Error while trying to save Items ---> \(error)")
        }
        loadCategories()
    }
    
}

extension CategoryViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            loadCategories()
        }
        else {
        var request = Category.fetchRequest()
        let predicate = NSPredicate(format: "titleCategory CONTAINS [cd] %@", searchBar.text as! CVarArg)
        let sortDesciptor = NSSortDescriptor(key: "dateCategory", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sortDesciptor]
        do {
        categoryEntity = try context.fetch(request)
    }
        catch {
            print("Error while trying to load Items ---> \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
}
