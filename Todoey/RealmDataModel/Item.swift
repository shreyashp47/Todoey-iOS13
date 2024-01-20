//
//  Item.swift
//  Todoey
//
//  Created by Shreyash Pattewar on 07/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic  var title: String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
    
    
    
    var parentCategry = LinkingObjects(fromType: Category.self, property: "items")
}
