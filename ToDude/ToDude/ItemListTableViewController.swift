//
//  ItemListTableViewController.swift
//  ToDude
//
//  Created by Rachel Wong on 21/1/21.
//

import UIKit
import CoreData

class ItemListTableViewController: UITableViewController {

  var items = [Item]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return 5 // items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let index = indexPath.row
        // Configure the cell...
        cell.textLabel?.text = "Item #"
        cell.accessoryType = index % 2 == 0 ? .checkmark : .none
        return cell
    }

}
