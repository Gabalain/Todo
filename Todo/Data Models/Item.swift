//
//  toDoModel.swift
//  Todo
//
//  Created by Alain Gabellier on 27/08/2018.
//  Copyright © 2018 Alain Gabellier. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
