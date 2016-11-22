//
//  AppDelegate.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/9.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 注册通知
        addNotification()
        
        // 配置第三方sdk
        configThridSDK()
        
        // 创建窗口
        createKeyWindow()
        
        return true
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: Selector(("showAdvertiseOnMainTabBarController:")), name: NSNotification.Name(rawValue: AdvertiseImageLoadSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("showMainTabBarControllerWithNoAdvertise")), name: NSNotification.Name(rawValue: AdvertiseImageLoadFailure), object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("showMainTabBarControllerWithNoAdvertise")), name: NSNotification.Name(rawValue: NewFeatureViewControllerDidFinishedGuide), object: nil)
    }
    
    fileprivate func configThridSDK() {
        
    }
    
    fileprivate func createKeyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if isNewUpdate() {
             window?.rootViewController = NewFeatureViewController()
        } else {
            window?.rootViewController = SLTabBarController()
            loadADViewController()
        }
    }
    
    /**
     加载广告视图
     //思路：
     1.一般第一次进入app不加载广告，先下载到本地，
     2.下次进入app展示广告并获取是否有新广告，
     3.有则下载并删除旧广告缓存
     */
    private func loadADViewController() {
        let adView = AdvertiseView.advertiseView()
        adView.show()
    }
    
    /**
     清除通知 清除缓存
     */
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

