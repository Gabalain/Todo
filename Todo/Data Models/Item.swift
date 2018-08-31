//
//  Item.swift
//  Todo
//
//  Created by Alain Gabellier on 30/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var creationDate: Date?
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
