//
//  Trip.swift
//  Knapsack
//
//  Created by manatee on 7/18/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift


class Trip: Object {
  @objc dynamic var id = ""
  @objc dynamic var tripName = "defaulttripname"
  @objc dynamic var startDate = "date"
  @objc dynamic var numberOfDays = "five"
  @objc dynamic var endDate = NSDate()
  @objc dynamic var tripImage = "imagePath"
  @objc dynamic var archived = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  let lists = List<ItemList>()
}


class ItemList: Object {
  @objc dynamic var id = ""
  @objc dynamic var listName = "name"
  @objc dynamic var listImage = "listTemp.png"
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  let items = List<Item>()
  
  var listsTrip = LinkingObjects(fromType: Trip.self, property: "lists")
}


class Item: Object {
  @objc dynamic var id = ""
  @objc dynamic var itemName = "name"
  @objc dynamic var itemCategory = "category"
  @objc dynamic var itemCount: Int = 0
  @objc dynamic var itemImage = "imagePath"
  @objc dynamic var packed: Bool = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  var itemsList = LinkingObjects(fromType: ItemList.self, property: "items")
  
}
