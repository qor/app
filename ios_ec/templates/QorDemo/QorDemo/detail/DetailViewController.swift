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
    let bottomHeight:CGFloat = 50
    var bannerImgV = UIImageView(frame: CGRectZero)
    var titleLbl = UILabel(frame: CGRectZero)
    var descLbl = UILabel(frame: CGRectZero)
    var bottomView = UIView(frame: CGRectZero)
    var cartBtn = UIButton(type: .Custom)
    var amountLbl = UILabel(frame: CGRectZero)
    var lineV = UIView(frame: CGRectZero)
    
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
        
        view.addSubview(bottomView)
        view.addSubview(bannerImgV)
        view.addSubview(titleLbl)
        view.addSubview(descLbl)
        bottomView.addSubview(lineV)
        bottomView.addSubview(cartBtn)
        bottomView.addSubview(amountLbl)
        
        lineV.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        
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
        
        updateAmountWithStr("20 件")
        
        setupConstraints()
    }
    
    func updateAmountWithStr(amountStr: String) {
        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(18) ]
        let myString = NSMutableAttributedString(string: "当前库存: ", attributes: myAttribute )
        
        let attrString = NSAttributedString(string: amountStr)
        myString.appendAttributedString(attrString)
        
        let myRange = NSRange(location: 6, length: attrString.length)
        myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: myRange)
        
        amountLbl.attributedText = myString
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
        
        constrain(bottomView) { (b) in
            b.height == bottomHeight
            b.leading == b.superview!.leading
            b.trailing == b.superview!.trailing
            b.bottom == b.superview!.bottom
        }
        
        constrain(lineV) { (l) in
            l.height == 1
            l.leading == l.superview!.leading
            l.trailing == l.superview!.trailing
            l.top == l.superview!.top
        }
        
        constrain(cartBtn) { (c) in
            c.top == c.superview!.top
            c.bottom == c.superview!.bottom
            c.trailing == c.superview!.trailing
            c.width == c.superview!.width / 3
        }
        
        constrain(amountLbl) { (a) in
            a.top == a.superview!.top
            a.bottom == a.superview!.bottom
            a.leading == a.superview!.leading + 20
        }
        
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
        
        constrain(descLbl, bottomView) { (d, b) in
            d.bottom == b.top - 20
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
