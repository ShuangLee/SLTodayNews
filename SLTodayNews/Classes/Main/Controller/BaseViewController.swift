//
//  BaseViewController.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/10.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SLGlobalColor()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setBackgroundColor(SLColor(0, g: 0, b: 0, a: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
}
