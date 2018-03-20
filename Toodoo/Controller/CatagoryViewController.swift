//
//  CatagoryViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/16/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit
import RealmSwift

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        cell.textLabel?.text = catagoryArray?[indexPath.row].name ?? "No Catagories yet!"
        
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
