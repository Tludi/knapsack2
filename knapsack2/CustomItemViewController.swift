//
//  CustomItemViewController.swift
//  
//
//  Created by manatee on 8/8/16.
//
//

import UIKit
import RealmSwift

class CustomItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var realm = try! Realm()
  let customList = try! Realm().objects(ItemList).filter("id = '2'").first!

  
  @IBOutlet weak var customItemTable: UITableView!
  @IBOutlet weak var testLabel: UILabel!

  @IBOutlet weak var addItemField: UITextField!
  
  @IBAction func addItemButton(sender: UIButton) {
//    testLabel.text = addItemField.text!
    
    let realm = try! Realm()
    let newItem = Item()
    
    if let newItemName = addItemField.text {
      if newItemName == "" {
        let noNameAlert = UIAlertController(title: "Item Name", message: "Name Can Not Be Blank", preferredStyle: .Alert)
        noNameAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
          return
        }))
        self.presentViewController(noNameAlert, animated: true, completion: nil)
      } else {
        newItem.id = NSUUID().UUIDString
        newItem.itemCategory = "custom items"
        newItem.itemName = (addItemField.text?.capitalizedString)!
    
        try! realm.write {
          customList.items.append(newItem)
          print("added \(newItem.itemName)")
        }
      
        addItemField.text = ""
        addItemField.resignFirstResponder()
        customItemTable.reloadData()
      }
    }
  }


  
  override func viewDidLoad() {
    super.viewDidLoad()
    testLabel.layer.masksToBounds = true
    testLabel.layer.cornerRadius = 7
    testLabel.text = "Add your custom item."
    
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return customList.items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("customItemCell", forIndexPath: indexPath)
    let customItems = customList.items
    let customItem = customItems[indexPath.row]
    let customItemLabel = cell.contentView.viewWithTag(1) as! UILabel
    let customIcon = cell.contentView.viewWithTag(5) as! UIImageView
    customItemLabel.text = customItem.itemName
    customIcon.image = UIImage(named: "customIcon")
    return cell
  }
  
  
  
  
  //*** Edit and Delete Custom Items

  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  
  
  //  Trip table cell actions - Edit, Delete
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
    
    
    
    // Delete trip functions
    let deleteCellAction = UITableViewRowAction(style: .Normal, title: "    ") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
      print("delete action")
      let deleteAlert = UIAlertController(title: "Confirm Delete", message: "Selected Trip Will be DELETED!", preferredStyle: .Alert)
      deleteAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction) in
        try! self.realm.write {
          let selectedItem = self.customList.items[indexPath.row]
          self.realm.delete(selectedItem)
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }))
      deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
        return
      }))
      self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    let deleteImage = UIImage(named: "deleteBoxMD.png")!
    deleteCellAction.backgroundColor = UIColor(patternImage: deleteImage)
    
    // first item in array is far right in cell
    return [deleteCellAction]
  }



}
