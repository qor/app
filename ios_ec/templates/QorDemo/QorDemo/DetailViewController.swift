//
//  DetailViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imgUrlStr: String?

    @IBOutlet weak var bannerImgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let str = imgUrlStr {
            bannerImgV.kf_setImageWithURL(NSURL(string: str)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
