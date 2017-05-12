//
//  MasterItemViewController.swift
//  knapsack
//
//  Created by manatee on 7/30/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift


class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var realm = try! Realm()
  var trips = try! Realm().objects(Trip)
  var passedList = ItemList()
  var passedTrip = Trip()
  
  var allItems = MasterItemList()
  var categories = MasterItemList().categories.sort()
  let customList = try! Realm().objects(ItemList).filter("id = '2'").first!
  
  @IBOutlet weak var categoryTable: UITableView!
  @IBOutlet weak var tripLengthLabel: UILabel!
  
  
  override func viewWillAppear(animated: Bool) {
    categoryTable.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Categories"
    tripLengthLabel.text = "Packing for \(passedTrip.numberOfDays) days"
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      return allItems.categories.count
    } else {
      if customList.items.count > 0 {
        return 1
      } else {
        return 0
      }
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
    let categoryLabelName = cell.contentView.viewWithTag(1) as! UILabel
    let categoryImage = cell.contentView.viewWithTag(5) as! UIImageView
    
    if indexPath.section == 0 {
      categoryLabelName.text = "Custom"
      categoryImage.image = UIImage(named: "customIcon")
    } else if indexPath.section == 1 {
      
      let category = categories[indexPath.row]
      categoryLabelName.text = category.capitalizedString
    
    // Image for Category
    // Image Icon needs to be named 'category'Icon
      categoryImage.image = UIImage(named: "\(category)Icon")
    }
    
    return cell
    
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showCategoryItems" {
      if let destinationController = segue.destinationViewController as? CategoryListViewController {
        
        if let categoryIndex = categoryTable.indexPathForSelectedRow {
          var categoryToPass = ""
          var listToPass = passedList
          if categoryIndex.section == 0 {
            categoryToPass = "custom items"
            listToPass = customList
          } else {
            categoryToPass = categories[categoryIndex.row]
            listToPass = passedList
          }
          
          
          destinationController.passedCategory = categoryToPass
          destinationController.passedList = listToPass
          destinationController.passedTrip = passedTrip
        }
      }
    }
  }


}
