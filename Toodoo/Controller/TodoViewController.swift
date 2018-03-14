//
//  ViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/12/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {

    var itemArray = [ListItem]()
    
    
    //let userStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let list = userStorage.array(forKey: "UserArray") as? [ListItem] {
//            itemArray = list
//        }
        
        for x in 0...20 {
            let y = ListItem()
            y.title = "\(x)"
            itemArray.append(y)
           
        }
        
        
//        let newItem = ListItem()
//        newItem.title = "one"
//        itemArray.append(newItem)
//
//        let newItem2 = ListItem()
//        newItem2.title = "two"
//        itemArray.append(newItem2)
//
//        let newItem3 = ListItem()
//            newItem3.title = "three"
//        itemArray.append(newItem3)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].status == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if itemArray[indexPath.row].status == false {
            itemArray[indexPath.row].status = true
            
        } else {
            itemArray[indexPath.row].status = false
        }
        
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addToList(_ sender: UIBarButtonItem) {
        var addText = UITextField()
        let alert = UIAlertController(title: "New TooDoo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = ListItem()
            item.title = addText.text!
            self.itemArray.append(item)
            //self.userStorage.set(self.itemArray, forKey: "UserArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "this is where you type something"
            addText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

