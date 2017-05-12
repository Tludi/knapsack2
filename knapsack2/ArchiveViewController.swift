//
//  ArchiveViewController.swift
//  knapsack
//
//  Created by manatee on 8/12/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class ArchiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var realm = try! Realm()
  var allTrips = try! Realm().objects(Trip)
  
  var archivedTrips = try! Realm().objects(Trip).filter("archived = true").sorted("startDate")
  var selectedTrip = Trip()
  var showActiveTrips = true
  
  // get version and build of current app
  let version: AnyObject = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]!
  let build: AnyObject = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]!
  
  @IBOutlet weak var archiveTable: UITableView!
  
  @IBOutlet weak var versionLabel: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    versionLabel.text = "v. \(version) b. \(build)"
    
    // Set the background image of the trips table
    let bgImage: UIImage = UIImage(named: "iPhone5bg.png")!
    archiveTable.backgroundView = UIImageView(image: bgImage)
    self.title = "Archived Trips"
  }
  
  override func viewWillAppear(animated: Bool) {
    archiveTable.reloadData()
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return archivedTrips.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("archiveTripCell", forIndexPath: indexPath) 
    let trip = archivedTrips[indexPath.row]
    
    
    //**** hard coded --- FIX!
    // only counts the items in the default 'All Items List'
    // which is ok if All Items List includes items from other lists
    let allTripItems = trip.lists.first?.items.count
    
    
    let tripNameLabel = cell.contentView.viewWithTag(1) as! UILabel
    tripNameLabel.text = "\(trip.tripName)"
    // tripStartDate
    let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
    dateLabel.text = "\(trip.startDate)"
    // tripItems Total
    let itemLabel = cell.contentView.viewWithTag(4) as! UILabel
    itemLabel.text = "\(allTripItems!) items"
    // toggle archive flag based on trip status
//    let archiveFlag = cell.contentView.viewWithTag(5)
    
    // daysToGo label
//    let daysToGo = cell.contentView.viewWithTag(6) as! UILabel
    
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
    
    //****************** Copy trip functions
    //************* need to correct code for when there are more than one lists
    
    let copyCellAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "    "){ (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      
      self.selectedTrip = self.archivedTrips[indexPath.row]
      // set new trip
      let copiedTrip = Trip()
      copiedTrip.id = NSUUID().UUIDString
      copiedTrip.tripName = "\(self.selectedTrip.tripName)Copy"
      copiedTrip.startDate = self.selectedTrip.startDate
      copiedTrip.numberOfDays = self.selectedTrip.numberOfDays
      try! self.realm.write {
        self.realm.add(copiedTrip, update: false)
      }
      
      
      for originalList in self.selectedTrip.lists {
        let newList = ItemList()
        newList.id = NSUUID().UUIDString
        newList.listName = originalList.listName
        
        try! self.realm.write {
          copiedTrip.lists.append(newList)
        }
      }
      
      // only copies the first list items
      for eachItem in self.selectedTrip.lists.first!.items {
        let newItem = Item()
        newItem.id = NSUUID().UUIDString
        newItem.itemName = eachItem.itemName
        newItem.itemCount = eachItem.itemCount
        newItem.itemCategory = eachItem.itemCategory
        try! self.realm.write {
          copiedTrip.lists.first!.items.append(newItem)
        }
      }

      self.archiveTable.reloadData()
    }
    
    let copyimage = UIImage(named: "copybox.png")!
    copyCellAction.backgroundColor = UIColor(patternImage: copyimage)
    
    
    // Delete trip functions
    let deleteCellAction = UITableViewRowAction(style: .Normal, title: "    ") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      print("delete action")
      let deleteAlert = UIAlertController(title: "Confirm Delete", message: "Selected Trip Will be DELETED!", preferredStyle: .Alert)
      deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction) in
        try! self.realm.write {
          let selectedTrip = self.archivedTrips[indexPath.row]
          self.realm.delete(selectedTrip)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }))
      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
        return
      }))
      self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    let deleteImage = UIImage(named: "deleteBoxLG.png")!
    deleteCellAction.backgroundColor = UIColor(patternImage: deleteImage)
    
    // first item in array is far right in cell
    return [deleteCellAction, copyCellAction]
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTripListsFromArchive" {
      if let destinationController = segue.destinationViewController as? TripListViewController {
        if let tripIndex = archiveTable.indexPathForSelectedRow {
          let chosenTrip = archivedTrips[tripIndex.row]
          destinationController.chosenTrip = chosenTrip
        }
      }
    }
  }

}
