//
//  ItemListTableViewController.swift
//  ToDude
//
//  Created by Rachel Wong on 21/1/21.
//

import UIKit
import CoreData
import SwipeCellKit

class ItemListTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var items = [Item]()
  
 
  @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
    let alertController = UIAlertController(
      title: "Add item",
      message: "",
      preferredStyle: .alert
    )
    
    var tempTextField = UITextField()
    
    let alertAction = UIAlertAction(title: "Done", style: .default) { (_) in
      let newItem = Item(context: self.context)
      if let text = tempTextField.text, text != "" {
        newItem.title = text
        newItem.completed = false
        
        self.items.append(newItem)
        self.saveItems()
      }
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Todo Title"
      tempTextField = textField
    }
    
    alertController.addAction(alertAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
      loadItems()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
      cell.delegate = self
      // Configure the cell...
      let item = items[indexPath.row]
      cell.textLabel?.text = item.title
      cell.accessoryType = item.completed ? .checkmark : .none
      return cell
    }
  
  // ------ DELETE ------
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation  == .right else {
      return nil
    }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (_, indexPath) in
      self.context.delete(self.items[indexPath.row]) // delete from DB
      self.items.remove(at: indexPath.row) // remove from array
      self.saveItems() // update and save to DB
    }
    // add delete img to action
    deleteAction.image = UIImage(named: "trash")
    
    return [deleteAction] // the array indicates that you can have multiple (optional) actions on the swipe action
  }
  
  // ----- UPDATE (TOGGLE COMPLETED) -----
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    items[indexPath.row].completed = !items[indexPath.row].completed
    saveItems()
  }
  
  // ------ CREATE ------
  func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving items")
    }
    tableView.reloadData()
  }
  
  // ------ READ ------
  func loadItems() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    do {
      items = try context.fetch(request)
    } catch {
      print("Error fetching items: \(error)") // you already have access in the catch, don't need to declare it
    }
    tableView.reloadData()
  }
  
 
}
