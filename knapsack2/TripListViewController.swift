//
//  TripListViewController.swift
//  knapsack
//
//  Created by manatee on 7/30/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class TripListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // Trip selected
  var chosenTrip = Trip()
  let customList = try! Realm().objects(ItemList).filter("id = '2'").first!
  // why is this here?
  var allTrips = try! Realm().objects(Trip)

  @IBOutlet weak var listTable: UITableView!
  @IBOutlet weak var tripNameLabel: UILabel!
  
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // try to hide the addButton. Show for testing
    addButton.tintColor = UIColor.clearColor()
    // set trip label to name of current trip
    tripNameLabel.text = chosenTrip.tripName
    // Set label of current page
    self.title = "Packing List"
    // Set the background image of the trips table
    let bgImage: UIImage = UIImage(named: "iPhone5bg.png")!
    listTable.backgroundView = UIImageView(image: bgImage)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    listTable.reloadData()
  }

  // set two sections - One for "All Items" and one for Categories
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  
  //*** Get number of rows per section **//
  //*** First section has only 1 row for all items ***//
  //*** Second section has rows based on categories that have items selected ***//
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let tripLists = chosenTrip.lists
    let selectedItems = tripLists[0].items.filter("itemCount > 0")
    var selectedCategories = [String]()
    for i in 0..<selectedItems.count {
      if selectedCategories.contains(selectedItems[i].itemCategory) == false {
        selectedCategories.append(selectedItems[i].itemCategory)
      }
    }
    // Return the number of rows in the section.
    if section == 1 { // SECOND SECTION
      if customList.items.filter("itemCount > 0").count > 0 {
        return 1
      } else {
        return 0
      }
    } else if section == 2 { // THIRD SECTION
      return selectedCategories.count
    } else {
      return 1 // FIRST and SECOND SECTION
    }
  }
  
  
  //*** Print the cells based on (1)all items, (2)custom intems and 
  //*** (3) categories of items selected  ***//
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) 
    let tripList = chosenTrip.lists[0]
    // Items from main list
    let selectedItems = tripList.items.filter("itemCount > 0")
    let unpackedItems = selectedItems.filter("packed = false")
    // Items from custom list
    let customItems = customList.items.filter("itemCount > 0")
    let customItemsLeft = customItems.filter("packed = false")

    // create an array of selectedCategories that have been selected
    var selectedCategories = [String]()
    for i in 0..<selectedItems.count {
      if selectedCategories.contains(selectedItems[i].itemCategory) == false {
        selectedCategories.append(selectedItems[i].itemCategory)
      }
    }
    
    //*** FIRST SECTION ***//
    //*** All Items ***//
    if indexPath.section == 0 {
      // Get total Items from Master List and Custom List that were chosen
      let totalItemsCount = selectedItems.count + customItems.count
      let totalUnpackedItemsCount = unpackedItems.count + customItemsLeft.count
      // List Name - has a tag of 1
      let listNameLabel = cell.contentView.viewWithTag(1) as! UILabel
      // get the default "All Items" List Name and assign to first section
      listNameLabel.text = "\(tripList.listName)"
      // Item Name
      let listItemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
      listItemNameLabel.text = "\(totalItemsCount) items"
      // Items Left to pack
      let itemsLeft = cell.contentView.viewWithTag(3) as! UILabel
      itemsLeft.text = "\(totalUnpackedItemsCount) left"
      // Image for All Items
      let categoryImage = cell.contentView.viewWithTag(5) as! UIImageView
      categoryImage.image = UIImage(named: "knapsackIcon")
      
      
      
      
    //*** SECOND SECTION ***//
    //*** Custom Items ***//
    } else if indexPath.section == 1 {
        // List Name - has a tag of 1
        let listNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        listNameLabel.text = "\(customList.listName)"
      // Item Name
        let listItemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        listItemNameLabel.text = "\(customItems.count) items"
      // Items Left to pack
        let itemsLeft = cell.contentView.viewWithTag(3) as! UILabel
        itemsLeft.text = "\(customItemsLeft.count) left"
        // Image for All Items
        let categoryImage = cell.contentView.viewWithTag(5) as! UIImageView
        categoryImage.image = UIImage(named: "customIcon")
      
      
      
      
    //*** THIRD SECTION ***//
    //*** Chosen Category Items ***//
    } else {
      // List Name - has a tag of 1
        let sortedCategories = selectedCategories.sort()
        let listNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let currentCategory = sortedCategories[indexPath.row]
        listNameLabel.text = currentCategory.capitalizedString
      // Category List
        let listItemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let categoryItems = selectedItems.filter("itemCategory = '\(currentCategory)'")
        listItemNameLabel.text = "\(categoryItems.count) items"
      // Items Left to pack
        let itemsLeft = cell.contentView.viewWithTag(3) as! UILabel
        let categoryItemsLeft = categoryItems.filter("packed = false")
        itemsLeft.text = "\(categoryItemsLeft.count) left"
      // Image for Category
      // Image Icon needs to be named 'category'Icon
        let categoryImage = cell.contentView.viewWithTag(5) as! UIImageView
        categoryImage.image = UIImage(named: "\(currentCategory)Icon")
    }
    
    return cell
  }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showListItems" {
      if let destinationController = segue.destinationViewController as? ListItemsViewController {
        if let listPath = listTable.indexPathForSelectedRow {
          let cell = tableView(listTable, cellForRowAtIndexPath: listPath)
          let category = cell.contentView.viewWithTag(1) as! UILabel
          
          // Current Trip first list - master List "All Items"
          let allItemsList = chosenTrip.lists[0]
          
          destinationController.chosenList = allItemsList
          destinationController.customList = customList
          destinationController.chosenCategory = category.text!
          destinationController.passedTrip = chosenTrip
        }
      }
    }
  }
  
  
}