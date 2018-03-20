//
//  ViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/12/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit
import RealmSwift

class TodoViewController: UITableViewController {

    var toDoItems: Results<ListItem>?
    let realm = try! Realm()
   
    var selectedCatagory: Catagory? {
        didSet {
           loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.status ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items yet!"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
            try realm.write {
                item.status = !item.status
                }
                } catch {
                    print(error)
            }
        }
        tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func addToList(_ sender: UIBarButtonItem) {
        var addText = UITextField()
        let alert = UIAlertController(title: "New TooDoo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCatagory = self.selectedCatagory {
                do{
                try self.realm.write {
                    let item = ListItem()
                    item.title = addText.text!
                    item.date = Date()
                    currentCatagory.items.append(item)
                }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "this is where you type something"
            addText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveData () {
//        do {
//           try context.save()
//        } catch {
//            print("Could not save because \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func loadData() {
        toDoItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}
    
//MARK: - Search Bar Delegate

extension TodoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
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

