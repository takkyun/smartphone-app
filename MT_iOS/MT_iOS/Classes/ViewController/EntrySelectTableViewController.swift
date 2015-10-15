//
//  EntrySelectTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/05.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntrySelectTableViewController: BaseTableViewController {
    var object: EntrySelectItem!
    var selected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = object.label
        
        selected = object.selected
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arw"), left: true, target: self, action: "backButtonPushed:")

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return object.list.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        let text = object.list[indexPath.row]
        cell.textLabel?.text = text
        
        if selected == text {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previous = object.list.indexOf(selected);
        if previous != indexPath.row {
            let prevRow = NSIndexPath(forRow: previous!, inSection: indexPath.section)
            tableView.beginUpdates();
            tableView.reloadRowsAtIndexPaths([indexPath, prevRow], withRowAnimation: .Fade)
            tableView.endUpdates();

            selected =  object.list[indexPath.row]
            object.selected = selected
            object.isDirty = true
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
        }
    }

    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
