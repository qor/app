//
//  SectionsTableViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Kingfisher

class ListTableViewController: UITableViewController {

    var items :[Product] = []
    let cellReuseStr = "ReuseStr"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Product List"
        
        tableView.registerClass(ListCell.self, forCellReuseIdentifier: cellReuseStr)
        
        getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getData() {
        APIClient.sharedClient.get(path: "/products.json", modelClass: ItemList.self) { (model) in
            
            if !model.isError {
                print("/products.json item list count: \((model as! ItemList).products.count)")
                
                self.items = (model as! ItemList).products
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Network error", message: "try again?", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (a) in
                    self.getData()
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseStr, forIndexPath: indexPath) as! ListCell

        let model = items[indexPath.row]
        cell.refreshCellWithModel(model)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detailVC = DetailViewController()
        detailVC.product = items[indexPath.row]
        
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    
}
