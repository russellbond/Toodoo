//
//  Catagory.swift
//  Toodoo
//
//  Created by Mac Pro on 3/18/18.
//  Copyright © 2018 RBond. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory : Object {
    @objc dynamic var name: String = ""
    let items = List<ListItem>() // this is the RELATIONSHIP between Catagory and ListItems variable.
}
