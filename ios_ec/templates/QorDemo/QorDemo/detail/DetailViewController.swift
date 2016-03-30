//
//  DetailViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography

class DetailViewController: UIViewController {
    
    var imgUrlStr: String?

    var bannerImgV = UIImageView(frame: CGRectZero)
    var titleLbl = UILabel(frame: CGRectZero)
    var descLbl = UILabel(frame: CGRectZero)
    var buyBtn = UIButton(type: .Custom)
    var cartBtn = UIButton(type: .Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "商品详情"
        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor.whiteColor()
        
        let rightItem = UIBarButtonItem(title: "我的购物车", style: .Plain, target: self, action: #selector(goToCart))
        navigationItem.rightBarButtonItem = rightItem
        
        setupBasicUI()
    }
    
    func goToCart() {
        let cartVC = CartViewController()
        navigationController!.pushViewController(cartVC, animated: true)
    }
    
    func setupBasicUI() {
        view.addSubview(bannerImgV)
        view.addSubview(titleLbl)
        view.addSubview(descLbl)
        view.addSubview(cartBtn)
        view.addSubview(buyBtn)
        
        titleLbl.font = UIFont.boldSystemFontOfSize(15)
        titleLbl.textColor = UIColor.blackColor()
        titleLbl.text = "商品介绍"
        
        descLbl.numberOfLines = 0
        descLbl.textColor = UIColor.lightGrayColor()
        descLbl.font = UIFont.systemFontOfSize(13)
        descLbl.text = "优点 \n1.指纹解锁确实很快\n2.外观秀气，精致，别出心裁的原型话筒\n3.屏幕触摸灵敏，虽然像素和色彩有些差，考虑到价钱方面还是蛮好的\n4.系统流畅，操作不卡顿，打开软件反应不慢\n5.冷藏室实用啊"
        
        cartBtn.setTitle("加入购物车", forState: .Normal)
        cartBtn.backgroundColor = UIColor.orangeColor()
        cartBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cartBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        cartBtn.addTarget(self, action: #selector(addToCart), forControlEvents: .TouchUpInside)
        
        buyBtn.setTitle("立即购买", forState: .Normal)
        buyBtn.backgroundColor = UIColor.greenColor()
        buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buyBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        buyBtn.addTarget(self, action: #selector(buy), forControlEvents: .TouchUpInside)
        
        setupConstraints()
    }
    
    func addToCart() {
        goToCart()
    }
    
    func buy() {
        let alertController = UIAlertController(title: "恭喜", message: "购买成功，回到首页", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        
        constrain(bannerImgV) { (b) in
            b.top == b.superview!.top
            b.width == b.height
            b.centerX == b.superview!.centerX
            b.height == 200
        }
        
        constrain(titleLbl, bannerImgV) { (t, b) in
            t.top == b.bottom + 20
        }
        constrain(titleLbl) { (t) in
            t.leading == t.superview!.leading + 20
            t.height == 20
        }
        
        constrain(descLbl, titleLbl) { (d, t) in
            d.top == t.bottom + 15
            d.centerX == d.superview!.centerX
            d.leading == d.superview!.leading + 20
        }
        
        constrain(cartBtn, descLbl) { (c, d) in
            c.top == d.bottom + 20
            c.width == c.superview!.width/2
            c.height == 40
            c.leading == c.superview!.leading
            c.bottom == c.superview!.bottom
        }
        
        constrain(buyBtn, cartBtn) { (b, c) in
            b.width == c.width
            b.height == c.height
            b.top == c.top
            b.leading == c.trailing
        }
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
}
