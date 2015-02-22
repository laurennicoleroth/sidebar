//
//  SidebarTableViewController.swift
//  sidebar
//
//  Created by norly on 2/22/15.
//  Copyright (c) 2015 norly. All rights reserved.
//

import UIKit

protocol SidebarTableViewControllerDelegate{
    func sidebarControlDidSelectRow(indexPath: NSIndexPath)
}

class SidebarTableViewController: UITableViewController {
    
    var delegate: SidebarTableViewControllerDelegate?
    var tableData = [String]()

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel!.text = tableData[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.frame = cell.frame
        selectedBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sidebarControlDidSelectRow(indexPath)
    }
}
