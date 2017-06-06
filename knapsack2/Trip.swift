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
  dynamic var id = ""
  dynamic var tripName = "defaulttripname"
  dynamic var startDate = "date"
  dynamic var numberOfDays = "five"
  dynamic var endDate = NSDate()
  dynamic var tripImage = "imagePath"
  dynamic var archived = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  let lists = List<ItemList>()
}


class ItemList: Object {
  dynamic var id = ""
  dynamic var listName = "name"
  dynamic var listImage = "listTemp.png"
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  let items = List<Item>()
  
  var listsTrip = LinkingObjects(fromType: Trip.self, property: "lists")
}


class Item: Object {
  dynamic var id = ""
  dynamic var itemName = "name"
  dynamic var itemCategory = "category"
  dynamic var itemCount: Int = 0
  dynamic var itemImage = "imagePath"
  dynamic var packed: Bool = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  var itemsList = LinkingObjects(fromType: ItemList.self, property: "items")
  
}
