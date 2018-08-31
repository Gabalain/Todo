//
//  Category.swift
//  Todo
//
//  Created by Alain Gabellier on 30/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
