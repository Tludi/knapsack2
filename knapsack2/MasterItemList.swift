//
//  MasterItemList.swift
//  knapsack
//
//  Created by manatee on 8/4/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import Foundation
import RealmSwift


//*** populates database with base items if masterlist does not exist ***//

class DataManager {
  class func populateRealm() -> Void {
    let realm = try! Realm()
    
    let masterCategories = MasterItemList().categories
    let masterItems = MasterItemList().itemList
    
    let masterListWithAllItems = ItemList()
    masterListWithAllItems.id = "1"
    masterListWithAllItems.listName = "Master Item List"
    
    try! realm.write {
      realm.add(masterListWithAllItems)
      print("added master list")
    }
    
    for category in masterCategories {
      let categoryList = masterItems[category]!
      for item in categoryList {
        
        let newItem = Item()
        newItem.id = NSUUID().uuidString
        newItem.itemCategory = category
        newItem.itemName = item
        
        try! realm.write {
          masterListWithAllItems.items.append(newItem)
          print("added \(newItem.itemName)")
        }
      }
    }
    
    let customItemList = ItemList()
    customItemList.id = "2"
    customItemList.listName = "Custom Items"
    
    try! realm.write {
      realm.add(customItemList)
      print("added custom list")
    }
    
  }
}
