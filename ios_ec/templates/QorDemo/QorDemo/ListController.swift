//
//  ListController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit

class ListController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 100
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionCell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "phone"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
