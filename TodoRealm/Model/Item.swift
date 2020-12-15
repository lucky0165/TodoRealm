//
//  Item.swift
//  TodoRealm
//
//  Created by Łukasz Rajczewski on 15/12/2020.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
