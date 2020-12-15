//
//  Category.swift
//  TodoRealm
//
//  Created by Łukasz Rajczewski on 13/12/2020.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
