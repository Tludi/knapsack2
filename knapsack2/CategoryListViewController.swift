//
//  CategoryListViewController.swift
//  knapsack
//
//  Created by manatee on 8/2/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var realm = try! Realm()
  var passedTrip = Trip()
  var passedCategory = "clothing"
  var passedList = ItemList()
  var masterList = MasterItemList().itemList
  
  
  
  @IBOutlet weak var tripLengthLabel: UILabel!
  
  @IBOutlet weak var itemTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = passedCategory.capitalizedString
    tripLengthLabel.text = "Packing for \(passedTrip.numberOfDays) days"
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let categoryItemList = passedList.items.filter("itemCategory = '\(passedCategory)'")
    return categoryItemList.count
  }
  
  
  
  // show cell
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("categoryItemCell", forIndexPath: indexPath)
    
    // get current saved items from the passed list
    let categoryItemList = passedList.items.filter("itemCategory = '\(passedCategory)'")
    let sortedCategoryItemList = categoryItemList.sorted("itemName")
    let item = sortedCategoryItemList[indexPath.row]
    
    // set cell labels
    let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
    let itemCountLabel = cell.contentView.viewWithTag(5) as! UILabel
    
    let increaseButton:UIButton = cell.contentView.viewWithTag(10) as! UIButton
    let decreaseButton:UIButton = cell.contentView.viewWithTag(11) as! UIButton
    let decreaseBackground = cell.viewWithTag(12)
    
    itemLabel.text = item.itemName
    itemCountLabel.text = "\(item.itemCount)"
    
    if item.itemCount > 0 {
      decreaseButton.alpha = 1.0
      decreaseBackground!.alpha = 1.0
    } else {
      decreaseButton.alpha = 0.0
      decreaseBackground?.alpha = 0.0
    }
    
    // #selector was updated from swift 2
    increaseButton.addTarget(self, action: #selector(CategoryListViewController.changeItemCount(_:)), forControlEvents: .TouchUpInside)
    decreaseButton.addTarget(self, action: #selector(CategoryListViewController.changeItemCount(_:)), forControlEvents: .TouchUpInside)
    
    return cell
  }
  
  
  
  func changeItemCount(sender : UIButton!) {
    let cell = sender.superview!.superview! as! UITableViewCell
    let itemLabel = cell.viewWithTag(1) as! UILabel
    let itemCountLabel = cell.viewWithTag(5) as! UILabel
    let increaseBackground = cell.viewWithTag(6)
    let decreaseButton:UIButton = cell.viewWithTag(11) as! UIButton
    let decreaseBackground = cell.viewWithTag(12) as! UIImageView
    let currentCount = Int((itemCountLabel.text)!)
    
    // this is an array of items
    let existingListItem = passedList.items.filter("itemName = '\(itemLabel.text!)'").first!
    
    // if plus(+) button is selected
    if sender.tag == 10 {
      if currentCount < 1 {
        decreaseButton.fadeIn()
        decreaseBackground.fadeIn()
      }
      
      let updatedCount = currentCount! + 1
      itemCountLabel.text = "\(updatedCount)"

      increaseBackground?.flash()
      
      try! realm.write{
        existingListItem.itemCount = updatedCount
      }
      
    // if minus(-) button is selected
    } else if sender.tag == 11 {
      
      let updatedCount = currentCount! - 1
      
      if updatedCount < 1 {
        itemCountLabel.text = "0"
        decreaseButton.fadeOut()
        decreaseBackground.fadeOut()
 
        // clear any packed items if removed from list
        try! realm.write{
          existingListItem.packed = false
        }

      } else {
        decreaseBackground.flash()
        itemCountLabel.text = "\(updatedCount)"
      }
      
      try! realm.write{
        existingListItem.itemCount = updatedCount
      }
      
    } else {

      self.itemTable.reloadData()
    }

    
  }
  
 


}
