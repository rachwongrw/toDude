//
//  ItemListTableViewController.swift
//  ToDude
//
//  Created by Rachel Wong on 21/1/21.
//

import UIKit
import CoreData
import SwipeCellKit

class ItemListTableViewController: UITableViewController {
  
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
    loadItems(search: nil)
    tableView.rowHeight = 85.0
  }

    // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  // ----- UPDATE (TOGGLE COMPLETED) -----
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    items[indexPath.row].completed = !items[indexPath.row].completed
    saveItems()
  }
  
  // ------ CREATE ------
  // MARK: - Helper Functions
  func saveItems() {
    do {
      try context.save()
    } catch {
      print("Error saving items")
    }
    tableView.reloadData()
  }
  
  // ------ READ ------
  func loadItems(search: String?) {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    if let searchText = search {
      let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
      request.predicate = predicate
      let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
      request.sortDescriptors = [sortDescriptor]
    }
 
    
    do {
      items = try context.fetch(request)
    } catch {
      print("Error fetching items: \(error)") // you already have access in the catch, don't need to declare it
    }
    tableView.reloadData()
  }
  
 
}

extension ItemListTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count > 0 {
      loadItems(search: searchText)
    } else if searchText.count == 0 {
      loadItems(search: nil)
    }
  }
}
