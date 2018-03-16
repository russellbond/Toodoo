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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let index = itemArray[indexPath.row]
        
        cell.textLabel?.text = index.title
        
        cell.accessoryType = index.status ? .checkmark : .none
        
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
    
    func loadData(with request: NSFetchRequest<ListItem> = ListItem.fetchRequest()) {
        //let request: NSFetchRequest<ListItem> = ListItem.fetchRequest()
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
        
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request)
    
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
