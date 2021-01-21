//
//  ItemListTableViewController.swift
//  ToDude
//
//  Created by Rachel Wong on 21/1/21.
//

import UIKit
import CoreData

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
      if let text = tempTextField.text {
        newItem.title = text
        newItem.completed = false
        
        self.items.append(newItem)
        self.saveiTems()
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
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        // Configure the cell...
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
  
  func saveiTems() {
    do {
      try context.save()
    } catch {
      print("Error saving items")
    }
    tableView.reloadData()
  }
}
