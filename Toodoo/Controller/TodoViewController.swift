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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ListData.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        
        //print(dataFilePath)
        
//        for x in 0...20 {
//            let y = ListItem()
//            y.title = "\(x)"
//            itemArray.append(y)
//        }
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
            
            let item = ListItem()
            item.title = addText.text!
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([ListItem].self, from: data)
        }catch {
            print(error)
            }
        }
    }
}
