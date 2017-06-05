//
//  ListItemsViewController.swift
//  knapsack
//
//  Created by manatee on 7/30/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class ListItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let realm = try! Realm()
  var passedTrip = Trip()
  var chosenList = ItemList()
  var customList = ItemList()
  var chosenCategory = String()
  let checkedButtonImage = UIImage(named: "squareCheck.png")
  let uncheckedButtonImage = UIImage(named: "squareCount.png")
  var filterCat :String = ""
//  let customList = try! Realm().objects(ItemList).filter("id = '2'").first!
  
  @IBOutlet weak var listName: UILabel!
  @IBOutlet weak var listItemTable: UITableView!
  @IBOutlet weak var addItemBox: UIView!
  @IBAction func addItemBoxButton(sender: UIButton) {
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the background image of the listItem table
    let bgImage: UIImage = UIImage(named: "iPhone5bg.png")!
    listItemTable.backgroundView = UIImageView(image: bgImage)

    //*** create a filter based on category passed or all items
    if chosenCategory == "All Items" {
      filterCat = "itemCount > 0"
    } else {
      filterCat = "itemCount > 0 AND itemCategory == '\(chosenCategory.lowercased())'"
    }
  }
  
  
  func viewWillAppear() {
    listName.text = chosenCategory
    
    // show/hide addItemBox based on if there are any items in the list
    addItemBox.layer.cornerRadius = 20
    if chosenList.items.filter("itemCount > 0").count > 0 {
      addItemBox.isHidden = true
    } else if customList.items.filter("itemCount > 0").count > 0 {
      addItemBox.isHidden = true
    } else {
      addItemBox.isHidden = false
    }
    listItemTable.reloadData()
  }
  
  //*** Only one section in this table ***//
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  //*** Number of rows based on selected items with a count ***//
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if chosenList.listName == "All Items" {
      if section == 0 {
//        print("section 0 has \(customList.items.filter(filterCat).count)")
        return customList.items.filter(filterCat).count
      } else {
        let itemsWithCount = chosenList.items.filter(filterCat)
//        print("section 1 has \(itemsWithCount.count)")
        return itemsWithCount.count      }
    } else {
      if section == 0 {
//        print(filterCat)
        let itemsWithCount = chosenList.items.filter(filterCat)
//        print(itemsWithCount.count)
        return itemsWithCount.count
      } else {
        return 0
        
      }
    }
  }
  
  
  
  
  //*** show cells based on All Items or individual category selected from segue
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var itemsWithCount = chosenList.items.filter(filterCat)
    
    if indexPath.section == 0 {
      itemsWithCount = customList.items.filter(filterCat)
    } else {
      itemsWithCount = chosenList.items.filter(filterCat)
    }
//    let sortedItemsWithCount = itemsWithCount.sorted("itemName") - Removed since sorting in database
    
    
    let item = itemsWithCount[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
    
    // List Name
    let listNameLabel = cell.contentView.viewWithTag(1) as! UILabel
    let categoryNameLabel = cell.contentView.viewWithTag(2) as! UILabel
    let itemIcon = cell.contentView.viewWithTag(3) as! UIImageView

    // box around item count that toggles when item is packed
    let checkBox:UIImageView = cell.contentView.viewWithTag(11) as!UIImageView
    // item count
    let itemCountLabel = cell.contentView.viewWithTag(20) as! UILabel
    // overlay to show when items are packed
    let itemOverlay = cell.contentView.viewWithTag(15)
    
    
    listNameLabel.text = item.itemName
    categoryNameLabel.text = item.itemCategory.capitalized
    itemCountLabel.text = "\(item.itemCount)"
    
    if indexPath.section == 0 {
      itemIcon.image = UIImage(named: "customIcon")
    } else {
      itemIcon.image = UIImage(named: "\(item.itemCategory)Icon")
    }
    
    // set checked image based on being packed
    if itemsWithCount[indexPath.row].packed == true {
      checkBox.image = checkedButtonImage
      itemOverlay?.isHidden = false
    } else {
      checkBox.image = uncheckedButtonImage
      itemOverlay?.isHidden = true
    }

    return cell
    
  }
  
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    var itemsWithCount = chosenList.items.filter(filterCat)
    if indexPath.section == 0 {
      itemsWithCount = customList.items.filter(filterCat)
    } else {
      itemsWithCount = chosenList.items.filter(filterCat)
    }
    let item = itemsWithCount[indexPath.row]
    
    let checkBox:UIImageView = cell?.contentView.viewWithTag(11) as! UIImageView
    if checkBox.isHidden == false {
      toggleCheckButton(selectedItem: item)
    }
  }
  
  //*** disabled deleting items from list due to it not actually removing items, just the cell ***//
  
//  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//    return true
//  }
//  
//  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//  }
  
  
  
  
//  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//    
//    // Delete trip functions
//    let deleteCellAction = UITableViewRowAction(style: .Normal, title: "    ") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
//      print("delete action")
//      let deleteAlert = UIAlertController(title: "Confirm Removal", message: "Selected Item Will Be Removed From List!", preferredStyle: .Alert)
//      deleteAlert.addAction(UIAlertAction(title: "Remove", style: .Default, handler: { (action: UIAlertAction) in
//        
//        let itemsWithCount = self.chosenList.items.filter(self.filterCat)
//
//        try! self.realm.write {
//          let selectedItem = itemsWithCount[indexPath.row]
//          selectedItem.itemCount = 0
//          if self.chosenList.items.count < 1 {
//            self.addItemBox.hidden = false
//          }
//        }
//        
//        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//      }))
//      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
//        return
//      }))
//      self.presentViewController(deleteAlert, animated: true, completion: nil)
//    }
//    
//    let deleteImage = UIImage(named: "deleteBoxSM.png")!
//    deleteCellAction.backgroundColor = UIColor(patternImage: deleteImage)
//    
//    return [deleteCellAction]
//  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAddItem" {
      if let destinationController = segue.destination as? CategoriesViewController {
        destinationController.passedList = chosenList
        destinationController.passedTrip = passedTrip
      }
    } else if segue.identifier == "addItemBox" {
      if let destinationController = segue.destination as? CategoriesViewController {
        destinationController.passedList = chosenList
        destinationController.passedTrip = passedTrip
      }
    }
  }

  
  func toggleCheckButton(selectedItem: Item) {
    try! realm.write {
      if selectedItem.packed == false {
        selectedItem.packed = true
      } else {
        selectedItem.packed = false
      }
    }
    listItemTable.reloadData()
  }

}
