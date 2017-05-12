//
//  NewListViewController.swift
//  knapsack
//
//  Created by manatee on 8/4/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift


class NewListViewController: UIViewController {
  let allLists = try! Realm().objects(ItemList.self)
  let masterList = try! Realm().objects(ItemList.self).filter("id = '1'")
  

  @IBOutlet weak var masterItemCount: UILabel!
  @IBOutlet weak var allListsCount: UILabel!
  @IBAction func populateMasterList(sender: UIButton) {
    checkForData()
  }
  
  @IBAction func deleteMasterList(sender: UIButton) {
    deleteMasterList()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    masterItemCount.text = "\(masterList.count)- Master List"
    allListsCount.text = "All Lists \(allLists.count)"
 
    
      // Do any additional setup after loading the view.
  }
  
  func checkForData() {
    if masterList.count == 0 {
      print("Master List Being Created")
      DataManager.populateRealm()
      masterItemCount.text = "\(masterList.count)"
      allListsCount.text = "All Lists \(allLists.count)"
    } else {
      let first = masterList.first!
      print("Master List Exists")
      print("\(first.items.count) items")
      masterItemCount.text = "\(masterList.count)-\(first.listName)"
    }
    
  }
  
  func deleteMasterList() {
    let realm = try! Realm()
    if masterList.count >= 1 {
      try! realm.write {
        realm.delete(self.masterList)
      }
      print("Deleted Master List")
    }
    masterItemCount.text = "\(masterList.count)"
    allListsCount.text = "All Lists \(allLists.count)"
  }


}
