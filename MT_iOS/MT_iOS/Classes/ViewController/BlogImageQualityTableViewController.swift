//
//  BlogImageQualityTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol BlogImageQualityDelegate {
    func blogImageQualityDone(controller: BlogImageQualityTableViewController, selected: Int)
}

class BlogImageQualityTableViewController: BaseTableViewController {

    var selected = NOTSELECTED
    var delegate: BlogImageQualityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Image Quality", comment: "Image Quality")
        self.tableView.backgroundColor = Color.tableBg
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
        return Blog.ImageQuality._Num.rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) 
        
        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        cell.textLabel?.text = Blog.ImageQuality(rawValue: indexPath.row)?.label()
        
        if selected == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 58.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previous = NSIndexPath(forRow: selected, inSection: indexPath.section);

        if previous.row != indexPath.row {
            tableView.beginUpdates();
            tableView.reloadRowsAtIndexPaths([indexPath, previous], withRowAnimation: .Fade)
            tableView.endUpdates();

            selected = indexPath.row
            delegate?.blogImageQualityDone(self, selected: selected)
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
        }
    }
}
