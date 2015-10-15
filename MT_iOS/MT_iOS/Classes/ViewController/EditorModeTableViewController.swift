//
//  EditorModeTableViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/25.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol EditorModeDelegate {
    func editorModeDone(controller: EditorModeTableViewController, selected: Entry.EditMode)
}

class EditorModeTableViewController: UITableViewController {
    var selected = Entry.EditMode.RichText
    var oldSelected = Entry.EditMode.RichText
    var delegate: EditorModeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("EditorMode", comment: "EditorMode")
        
        selected = oldSelected
        
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
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        // Configure the cell...
        cell.textLabel?.text = Entry.EditMode(rawValue: indexPath.row)?.label()
        if selected == Entry.EditMode(rawValue: indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previous = NSIndexPath(forRow: selected.rawValue, inSection: indexPath.section);

        if previous.row != indexPath.row {
            tableView.beginUpdates();
            tableView.reloadRowsAtIndexPaths([indexPath, previous], withRowAnimation: .Fade)
            tableView.endUpdates();

            selected = Entry.EditMode(rawValue: indexPath.row)!
            delegate?.editorModeDone(self, selected: selected)
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
        }
    }

    // MARK: - actions

    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
