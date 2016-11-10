//
//  SLTabBarController.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/10.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit

class SLTabBarController: UITabBarController {
    
    override class func initialize() {
        let tabBar = UITabBar.appearance()
        tabBar.tintColor = SLColor(111, g: 111, b: 111, a: 1.0)
        
        // 隐藏阴影线
        tabBar.shadowImage = UIImage()
        
        // 设置文字属性
        var attrs: [String: AnyObject] = Dictionary()
        attrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 12);
        attrs[NSForegroundColorAttributeName] = UIColor.gray
        var selectedAttrs : [String: AnyObject] = Dictionary()
        selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName]
        selectedAttrs[NSForegroundColorAttributeName] = SLColor(225, g: 62, b: 69, a: 1.0)
        
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes(attrs as [String: AnyObject], for: UIControlState.normal)
        item.setTitleTextAttributes(selectedAttrs as [String: AnyObject], for: UIControlState.selected)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加子控制器
        addChildViewControllers()
    }
    
    fileprivate func addChildViewControllers() {
        addChildViewController(HomeViewController(), title: "首页", imageName: "home_tabbar_22x22_", selectedImageName: "home_tabbar_press_22x22_")
        addChildViewController(VideoViewController(), title: "视频", imageName: "video_tabbar_22x22_", selectedImageName: "video_tabbar_press_22x22_")
        addChildViewController(FollowViewController(), title: "关注", imageName: "newcare_tabbar_22x22_", selectedImageName: "newcare_tabbar_press_22x22_")
        addChildViewController(MineViewController(), title: "我的", imageName: "mine_tabbar_22x22_", selectedImageName: "mine_tabbar_press_22x22_")
    }
    
    fileprivate func addChildViewController(_ childController: UIViewController, title: String, imageName: String, selectedImageName: String) {
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        childController.title = title
        
        let nav = SLNavigationViewController(rootViewController: childController)
        addChildViewController(nav)
    }
}
