//
//  CatagoryViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/16/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CatagoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var catagoryArray: Results<Catagory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCats()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = catagoryArray?[indexPath.row].name ?? "No Catagories yet!"
        cell.delegate = self
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToList", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let setItems = segue.destination as! TodoViewController
        if let index = tableView.indexPathForSelectedRow {
        setItems.selectedCatagory = catagoryArray?[index.row]
        }
        
    }
    
    func loadCats() {
        catagoryArray = realm.objects(Catagory.self)
        tableView.reloadData()
    }
    
    @IBAction func addCatagory(_ sender: UIBarButtonItem) {
        var addCat = UITextField()
        let alert = UIAlertController(title: "New Catagory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Catagory()
            item.name = addCat.text!
            
            self.saveCats(catagoryArray: item)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "this is where you type something"
            addCat = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveCats (catagoryArray: Catagory) {
        do {
            try realm.write {
                realm.add(catagoryArray)
            }
        } catch {
            print("Could not save because \(error)")
        }
        tableView.reloadData()
    }
}

extension CatagoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        let deleteAction = SwipeAction(style: .destructive, title: nil) {action, indexPath in
            
            if let item = self.catagoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                    }
                } catch {
                    print(error)
                }
                
            }
        }
        deleteAction.image = UIImage(named: "Trash")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
       
        return options
    
    }
}
