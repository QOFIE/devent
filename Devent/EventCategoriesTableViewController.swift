//
//  EventCategoriesTableViewController.swift
//  Devent
//
//  Created by Can Ceran on 28/11/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class EventCategoriesTableViewController: UITableViewController {
    
    // MARK: PROPOERTIES
    
    var categorySettings = [String:Bool]()
    var settingsChanged = false
    
    // MARK: ACTIONS
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        // Do nothing
    }
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        // Save the category choices to NSUserDefaults if there is a change
        if settingsChanged {
            // Save it to NSUserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            for (category, selection) in self.categorySettings {
                defaults.setObject(selection, forKey: category)
                print("\(category) is saved as \(defaults.boolForKey(category)) in defaults.")
            }
            defaults.synchronize()
            // Save it to Parse
            let user = PFUser.currentUser()
            var categoryChoicesArray: [String] = []
            for (category, selection) in categorySettings {
                if selection {
                    categoryChoicesArray.append(category)
                }
            }
            user?.setObject(categoryChoicesArray, forKey: USER.categoryChoices)
            user?.saveInBackground()
            print("Category Choices Array is \(user?.objectForKey(USER.categoryChoices)!)")
            
        }
        self.performSegueWithIdentifier("CancelUnwindSegue", sender: self)
    }
    
    private func updateCategoriesFromUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        for category in eventCategories {
            if let selection = defaults.objectForKey(category) as? Bool {
                categorySettings[category] = selection
            }
        }
        defaults.synchronize()
    }
    
    // MARK: VIEW CONTROLLER LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCategoriesFromUserDefaults()
        tableView.reloadData()
        tableView.setNeedsDisplay()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    // MARK: TABLE VIEW METHODS
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellImage = UIImage(named: "events")
        let category = eventCategories[indexPath.row]
        let cell =  tableView.dequeueReusableCellWithIdentifier("EventCategoryTableViewCell", forIndexPath: indexPath) as! EventCategoryTableViewCell
        cell.eventCategoryImageView.image = cellImage
        cell.eventCategoryLabel.text = category
        if let selection = categorySettings[category] {
            //print ("\(category) selected \(selection)")
            cell.accessoryType = selection ? .Checkmark : .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.settingsChanged = true
        let category = eventCategories[indexPath.row]
        print("Selected category is \(category)")
        if let selection = categorySettings[category] {
            if selection {
                self.categorySettings[category] = false
            } else {
                self.categorySettings[category] = true
            }
        }
        tableView.reloadData()
        tableView.setNeedsDisplay()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
