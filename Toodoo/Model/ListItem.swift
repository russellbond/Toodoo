//
//  ListItem.swift
//  Toodoo
//
//  Created by Mac Pro on 3/18/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import Foundation
import RealmSwift

class ListItem: Object {
    @objc dynamic var title = ""
    @objc dynamic var status = false
    @objc dynamic var date: Date?
    var parent = LinkingObjects(fromType: Catagory.self, property: "items") // this is the RELATIONSHIP back to Catagory from ListItems variable
}
