//
//  Data.swift
//  Todoey
//
//  Created by Shreyash Pattewar on 07/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var age: Int = 0
}
