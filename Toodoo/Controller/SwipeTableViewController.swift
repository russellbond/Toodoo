//
//  SwipeTableViewController.swift
//  Toodoo
//
//  Created by Mac Pro on 3/20/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {return nil}
        let deleteAction = SwipeAction(style: .destructive, title: nil) {action, indexPath in
            
            self.updateModel(at: indexPath)
            
            print("Delete Cell")
            
        }
        deleteAction.image = UIImage(named: "Trash")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
        
    }
    func updateModel(at indexPath: IndexPath) {
        //  creating this func in this SuperClass in order to trigger an Override later in the child ViewControllers
    }
}
