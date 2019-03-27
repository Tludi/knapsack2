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
  var trips = try! Realm().objects(Trip.self)
  var passedList = ItemList()
  var passedTrip = Trip()
  
  var allItems = MasterItemList()
  var categories = MasterItemList().categories.sorted()
  let customList = try! Realm().objects(ItemList.self).filter("id = '2'").first!
  
  @IBOutlet weak var categoryTable: UITableView!
  @IBOutlet weak var tripLengthLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    categoryTable.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Categories"
    tripLengthLabel.text = "Packing for \(passedTrip.numberOfDays) days"
    
    print(allItems.categories.count)
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // section 0 is the first section
    if section == 0 {
      return allItems.categories.count

    } else {
      if customList.items.count > 0 {
        return 1
      } else {
        return 0
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
    let categoryLabelName = cell.contentView.viewWithTag(1) as! UILabel
    let categoryImage = cell.contentView.viewWithTag(5) as! UIImageView
    
    if indexPath.section == 1 {
      categoryLabelName.text = "Custom"
      categoryImage.image = UIImage(named: "customIcon")
    } else if indexPath.section == 0 {
      
      let category = categories[indexPath.row]
      categoryLabelName.text = category.capitalized
    
    // Image for Category
    // Image Icon needs to be named 'category'Icon
      categoryImage.image = UIImage(named: "\(category)Icon")
    }
    
    return cell
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCategoryItems" {
      let destinationController = segue.destination as? CategoryListViewController
      let categoryIndex = categoryTable.indexPathForSelectedRow
        
        
      var categoryToPass = ""
      var listToPass = passedList
        
      if categoryIndex?.section == 1 {
         categoryToPass = "custom items"
         listToPass = customList
      } else {
        categoryToPass = categories[(categoryIndex?.row)!]
         listToPass = passedList
      }
          
          
        destinationController?.passedCategory = categoryToPass
        destinationController?.passedList = listToPass
        destinationController?.passedTrip = passedTrip
        
      
    }
  }


}
