//
//  ViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/12/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit
import CoreData
class TodoViewController: UITableViewController {

    var itemArray = [ListItem]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCatagory: Catagory? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].status ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // this is the boolean "reverse" true/false argument... which ever it is, make it the oposite. COOL!
        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addToList(_ sender: UIBarButtonItem) {
        var addText = UITextField()
        let alert = UIAlertController(title: "New TooDoo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = ListItem(context: self.context)
            item.title = addText.text!
            item.status = false
            item.parent = self.selectedCatagory
            self.itemArray.append(item)
            
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "this is where you type something"
            addText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData () {
        do {
           try context.save()
        } catch {
            print("Could not save because \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parent.name MATCHES %@", selectedCatagory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
}
    
//MARK: - Search Bar Delegate

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, predicate: predicate)
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
