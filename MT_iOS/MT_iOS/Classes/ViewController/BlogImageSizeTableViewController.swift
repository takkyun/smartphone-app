//
//  BlogImageSizeTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/09.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol BlogImageSizeDelegate {
    func blogImageSizeDone(controller: BlogImageSizeTableViewController, selected: Int)
}

class BlogImageSizeTableViewController: BaseTableViewController {
    var selected = NOTSELECTED
    var delegate: BlogImageSizeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Image Size", comment: "Image Size")
        self.tableView.backgroundColor = Color.tableBg

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
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
        return Blog.ImageSize._Num.rawValue
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) 

        self.adjustCellLayoutMargins(cell)
        
        // Configure the cell...
        cell.textLabel?.text = Blog.ImageSize(rawValue: indexPath.row)?.label()
        cell.detailTextLabel?.text = Blog.ImageSize(rawValue: indexPath.row)?.pix()
        
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
        selected = indexPath.row
        
        self.tableView.reloadData()
    }

    @IBAction func doneButtonPushed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.blogImageSizeDone(self, selected: selected)
    }
}
