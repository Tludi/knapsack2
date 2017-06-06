//
//  tripViewController.swift
//  knapsack2
//
//  Created by manatee on 6/5/17.
//  Copyright © 2017 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let allLists = try! Realm().objects(ItemList.self)
  let masterList = try! Realm().objects(ItemList.self).filter("id = '1'")
  
  @IBOutlet weak var tripTable: UITableView!
  @IBAction func clearDB(_ sender: UIBarButtonItem) {
    deleteMasterList()
  }
  
  func deleteMasterList() {
    let realm = try! Realm()
    if masterList.count >= 1 {
      try! realm.write {
        realm.delete(self.masterList)
      }
      print("Deleted Master List")
    } else {
      print("There is not a master list")
    }
//    masterItemCount.text = "\(masterList.count)"
//    allListsCount.text = "All Lists \(allLists.count)"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    let bgImage: UIImage = UIImage(named: "iPhone5bg.png")!
    tripTable.backgroundView = UIImageView(image: bgImage)
  
  }

  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
    let tripNameLabel = cell.viewWithTag(1) as! UILabel
    tripNameLabel.text = "hello"
    
    return cell
  }

}

