//
//  MenuTableViewController.swift
//  knapsack
//
//  Created by manatee on 7/27/15.
//  Copyright (c) 2015 diligentagility. All rights reserved.
//

import UIKit
//import RealmSwift

class MenuTableViewController: UITableViewController {

  var selectedMenuItem : Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    tableView.backgroundColor = UIColor.clearColor()
    // Uncomment the following line to preserve selection between presentations
    self.clearsSelectionOnViewWillAppear = false
    
    tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return 4
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
    
    if (cell == nil) {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
      cell!.backgroundColor = UIColor.clearColor()
      cell!.textLabel?.textColor = UIColor.darkGrayColor()
      let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
      selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
      cell!.selectedBackgroundView = selectedBackgroundView
    }
    
    cell!.textLabel?.text = "Item #\(indexPath.row+1)"
    
    return cell!
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
    header.contentView.backgroundColor = UIColor.whiteColor()
    
    header.textLabel!.textColor = UIColor.darkGrayColor()
    header.alpha = 0.3
    header.textLabel!.textAlignment = NSTextAlignment.Center
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30.0
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Knapsack"
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if (indexPath.row == selectedMenuItem) {
      return
    }
    
    selectedMenuItem = indexPath.row
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var destinationViewController: UIViewController!
    
    let selectedCell = tableView.cellForRowAtIndexPath(indexPath)!
    selectedCell.contentView.backgroundColor = UIColor.blueColor()
    
    switch (indexPath.row) {
    case 0:
      destinationViewController = storyboard.instantiateViewControllerWithIdentifier("ListItemTableController") as! TripListViewController
//      destinationViewController.title = "All Irises"
      break
//    case 1:
//      destinationViewController = storyboard.instantiateViewControllerWithIdentifier("BeardedController") as! BeardedController
//      destinationViewController.title = "Bearded"
//      break
//    case 2:
//      destinationViewController = storyboard.instantiateViewControllerWithIdentifier("BeardedController") as! BeardedController
//      destinationViewController.title = "Beardless"
//      break
//    case 3:
//      destinationViewController = storyboard.instantiateViewControllerWithIdentifier("FavoritesController") as! FavoritesController
//      destinationViewController.title = "Favorites"
//      break
    default:
      destinationViewController = storyboard.instantiateViewControllerWithIdentifier("TripTableController") as! TripViewController
//      destinationViewController.title = "IrisCodex"
      break
    }
    
//    sideMenuController()?.setContentViewController(destinationViewController)
  }

}
