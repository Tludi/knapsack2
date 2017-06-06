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

  
  let realm = try! Realm()
  var allTrips = try! Realm().objects(Trip.self)
  var activeTrips = try! Realm().objects(Trip.self).filter("archived = false").sorted(byKeyPath: "startDate")
  var selectedTrip = Trip()
  var showActiveTrips = true
  let currentDate = Date()
  
  
  @IBOutlet weak var tripTable: UITableView!
  @IBAction func clearDB(_ sender: UIBarButtonItem) {
    deleteMasterList()
  }
  
  @IBAction func toggleTripType(_ sender: UIBarButtonItem) {
    if showActiveTrips == true {
      showActiveTrips = false
      activeTrips = try! Realm().objects(Trip.self).filter("archived = true")
      self.title = "Archives"
    } else {
      showActiveTrips = true
      activeTrips = try! Realm().objects(Trip.self).filter("archived = false")
      self.title = "Active Trips"
    }
    tripTable.reloadData()
  }
  
  
  func deleteMasterList() {
//    let realm = try! Realm()
    // Fot testing
    let masterList = realm.objects(ItemList.self).filter("id = '1'")
    if masterList.count >= 1 {
      try! realm.write {
        realm.deleteAll()
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

