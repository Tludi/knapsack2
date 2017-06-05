//
//  TripViewController.swift
//  knapsack
//
//  Created by manatee on 7/30/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class TripViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  var realm = try! Realm()
  var allTrips = try! Realm().objects(Trip.self)
  var presentedTrips = try! Realm().objects(Trip.self).filter("archived = false").sorted(byKeyPath: "startDate")
  var selectedTrip = Trip()
  var showActiveTrips = true
  let currentDate = Date()
  
  @IBOutlet weak var infoButtonOutlet: UIBarButtonItem!
  @IBOutlet weak var bannerView: GADBannerView!

  @IBOutlet weak var addTripBox: UIView!
  
  @IBOutlet weak var itemTable: UITableView!
  
  @IBAction func addButton(sender: UIButton) {
  }
  
  @IBOutlet weak var toggleTripType: UIBarButtonItem!
  @IBAction func toggleTripType(sender: UIBarButtonItem) {
    if showActiveTrips == true {
      showActiveTrips = false
      presentedTrips = try! Realm().objects(Trip.self).filter("archived = true")
      self.title = "Archives"

    } else {
      showActiveTrips = true
      presentedTrips = try! Realm().objects(Trip.self).filter("archived = false")
      self.title = "Active Trips"

    }
    itemTable.reloadData()
  }
  
  

  @IBAction func cancelToNewTripViewController(segue:UIStoryboardSegue) {
    // this is set to unwind segues to the NewTripController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    infoButtonOutlet.isEnabled = false
    infoButtonOutlet.tintColor = UIColor.clear
    
    // Set the background image of the trips table
    let bgImage: UIImage = UIImage(named: "iPhone5bg.png")!
    itemTable.backgroundView = UIImageView(image: bgImage)
    
    // AdMob code
    print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
    // This is a test ID, use for testing
//    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    // This is the app unit ID for Admob - knapsack banner ad - front page
    bannerView.adUnitID = "ca-app-pub-9078081310752371/9311362449"
    print("remember to reset adUnitID to production if using testing ID")
    bannerView.rootViewController = self
    bannerView.load(GADRequest())

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // reload the table when coming back from another view
    addTripBox.layer.cornerRadius = 20
    
    if presentedTrips.count > 0 {
      addTripBox.isHidden = true
    } else {
      addTripBox.isHidden = false
    }
    
    itemTable.reloadData()
  }

  // **** Formatting the tableView *****//
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presentedTrips.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath as IndexPath) 
    let trip = presentedTrips[indexPath.row]
    
    //**** hard coded --- FIX!
    // only counts the items in the default 'All Items List'
    // which is ok if ALl Items List includes items from other lists
    let allTripItems = trip.lists.first?.items.filter("itemCount > 0").count
    
    // tripName
    let tripNameLabel = cell.contentView.viewWithTag(1) as! UILabel
    tripNameLabel.adjustsFontSizeToFitWidth = true
    tripNameLabel.text = "\(trip.tripName)"
    // tripStartDate
    let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
    dateLabel.text = "\(trip.startDate)"
    
    // Get days until Trip date
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let calendar = NSCalendar.current
    let _:NSCalendar.Unit = .day
    
    let convertedCurrentDate = calendar.startOfDay(for: currentDate)
//    let convertedCurrentDate = (calendar.startOfDayForDate(currentDate))
    let startDate = (calendar.startOfDay(for: dateFormatter.date(from: trip.startDate)!))
    
//    ********** Double check this calculation  *******
    let daysUntilTrip = startDate.timeIntervalSince(convertedCurrentDate)
//    let daysUntilTrip = calendar.components(unit, fromDate: convertedCurrentDate, toDate: startDate, options: [] ).day
    
    
    // tripItems Total
    let itemLabel = cell.contentView.viewWithTag(4) as! UILabel
    itemLabel.text = "\(allTripItems!) items"
    // toggle archive flag based on trip status
    let archiveFlag = cell.contentView.viewWithTag(5)
    if trip.archived == true {
      archiveFlag?.isHidden = false
    } else {
      archiveFlag?.isHidden = true
    }
    // daysToGo label
    let daysToGo = cell.contentView.viewWithTag(6) as! UILabel
    daysToGo.text = "\(daysUntilTrip)"
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  }

  
  
  
  //  Trip table cell actions - Copy, Edit, Delete
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

   
    //****************** Copy trip functions
    //************* need to correct code for when there are more than one lists
    let copyCellAction = UITableViewRowAction(style: .normal, title: "    ") {
      (UITableViewRowAction, indexPath) -> Void in
//    let copyCellAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "    "){ (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
    
      
      self.selectedTrip = self.presentedTrips[indexPath.row]
      // set new trip
      let copiedTrip = Trip()

      copiedTrip.id = NSUUID().uuidString
      copiedTrip.tripName = "\(self.selectedTrip.tripName)Copy"
      copiedTrip.startDate = self.selectedTrip.startDate
      copiedTrip.numberOfDays = self.selectedTrip.numberOfDays
      try! self.realm.write {
        self.realm.add(copiedTrip, update: false)
      }
      
      
      for originalList in self.selectedTrip.lists {
        let newList = ItemList()
        newList.id = NSUUID().uuidString
        newList.listName = originalList.listName
//        var originalItems = originalList.items

        try! self.realm.write {
          copiedTrip.lists.append(newList)
        }
      }
      
      // only copies the first list items
      for eachItem in self.selectedTrip.lists.first!.items {
        let newItem = Item()
        newItem.id = NSUUID().uuidString
        newItem.itemName = eachItem.itemName
        newItem.itemCount = eachItem.itemCount
        newItem.itemCategory = eachItem.itemCategory
        try! self.realm.write {
          copiedTrip.lists.first!.items.append(newItem)
        }
      }

      print("copy trip")
      self.itemTable.reloadData()
    }
    
    let copyimage = UIImage(named: "copybox.png")!
    copyCellAction.backgroundColor = UIColor(patternImage: copyimage)
    
    
    
    
    
    
    // Archive trip functions
    let archiveCellAction = UITableViewRowAction(style: .normal, title: "    ") {
      (UITableViewRowAction, indexPath) -> Void in
//    let archiveCellAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "    ") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      
      self.isEditing = false
      self.selectedTrip = self.presentedTrips[indexPath.row]
      try! self.realm.write {
        self.selectedTrip.archived = true
      }
      self.itemTable.reloadData()
    }
    let archiveimage = UIImage(named: "archivebox.png")!
    archiveCellAction.backgroundColor = UIColor(patternImage: archiveimage)
    
    // Edit trip functions
    let editCellAction = UITableViewRowAction(style: .normal, title: "    ") { (UITableViewRowAction, indexPath) -> Void in
      
      self.isEditing = false
      self.selectedTrip = self.presentedTrips[indexPath.row]
      self.performSegue(withIdentifier: "editTripData", sender: self)
    }
    let editimage = UIImage(named: "editbox.png")!
    editCellAction.backgroundColor = UIColor(patternImage: editimage)

    
    // Delete trip functions
    let deleteCellAction = UITableViewRowAction(style: .normal, title: "    ") {
      (UITableViewRowAction, indexPath) -> Void in
//    let deleteCellAction = UITableViewRowAction(style: .Normal, title: "    ") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      print("delete action")
      let deleteAlert = UIAlertController(title: "Confirm Delete", message: "Selected Trip Will be DELETED!", preferredStyle: .alert)
      deleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
        try! self.realm.write {
          let selectedTrip = self.presentedTrips[indexPath.row]
          self.realm.delete(selectedTrip)
          if self.presentedTrips.count == 0 {
            self.addTripBox.isHidden = false
          }
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
      }))
      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
        return
      }))
      self.present(deleteAlert, animated: true, completion: nil)
    }
    
    let deleteImage = UIImage(named: "deleteBoxLG.png")!
    deleteCellAction.backgroundColor = UIColor(patternImage: deleteImage)
    
    // first item in array is far right in cell
    return [deleteCellAction, editCellAction, copyCellAction, archiveCellAction]
  }
  
  
  

  
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTripLists" {
      if let destinationController = segue.destination as? TripListViewController {
        if let tripIndex = itemTable.indexPathForSelectedRow {
          let chosenTrip = presentedTrips[tripIndex.row]
          destinationController.chosenTrip = chosenTrip
        }
      }
    }
    
    if segue.identifier == "editTripData" {
      if let destinationController = segue.destination as? NewTripViewController {
          print("clicked edit trip")
          destinationController.editedTrip = selectedTrip
          destinationController.editToggle = true
      }
    }
  } // end prepareforsegue



}
