import UIKit
import CoreData
import SwipeCellKit

extension ItemListTableViewController: SwipeTableViewCellDelegate {
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
    cell.delegate = self
    
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
}
