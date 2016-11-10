//
//  SLNavigationViewController.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/10.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit

class SLNavigationViewController: UINavigationController {
    override class func initialize() {
        let  bar = UINavigationBar.appearance()
        // 隐藏阴影线
        bar.shadowImage = UIImage()
        bar.isTranslucent = true
        
        // 设置导航条标题字体大小和颜色
        bar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName: UIColor.white]
        bar.tintColor = SLColor(0, g: 0, b: 0, a: 0.7)
        bar.barTintColor = UIColor.white
        
        // 设置item
        let item = UIBarButtonItem.appearance()
        var itemAttrs: [String: AnyObject] = Dictionary()
        itemAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 15)
        itemAttrs[NSForegroundColorAttributeName] = UIColor.white
        item.setTitleTextAttributes((itemAttrs as [String: AnyObject]), for: UIControlState.normal)
        
        var itemDisabledAttrs: [String: AnyObject] = Dictionary()
        itemDisabledAttrs[NSFontAttributeName] = itemAttrs[NSFontAttributeName]
        itemDisabledAttrs[NSForegroundColorAttributeName] = UIColor.lightGray
        item.setTitleTextAttributes(itemDisabledAttrs as [String: AnyObject], for: UIControlState.disabled)
    }
    
    /**
     * 可以在这个方法中拦截所有push进来的控制器
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "lefterbackicon_titlebar_28x28_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)

    }
    
    func navigationBack() {
        popViewController(animated: true)
    }
}
