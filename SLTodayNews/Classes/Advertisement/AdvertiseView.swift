//
//  AdvertiseView.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/10.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit

class AdvertiseView: UIView {
    @IBOutlet weak var countDownButton: UIButton!
    @IBOutlet weak var adImageView: UIImageView!
    
    fileprivate lazy var countTimer: Timer? = {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(countDownDuration), userInfo: nil, repeats: true)
        return timer
    }()
    
    fileprivate var count: Int = 0
    var filePath: String? {
        didSet {
            if filePath != nil {
                adImageView.image = UIImage(contentsOfFile: filePath!)
            }
        }
    }
    
    /// 计时器开始
    func countDownDuration() {
        count = count - 1
        countDownButton.setTitle("跳过\(count)秒", for: .normal)
        if count == 0 {
            self.countTimer!.invalidate()
            self.countTimer = nil
            dismiss()
        }
    }
    
    class func advertiseView() -> AdvertiseView {
        let advertiseView = Bundle.main.loadNibNamed("AdvertiseView", owner: nil, options: nil)?.last
        (advertiseView as! AdvertiseView).frame = UIScreen.main.bounds
        return advertiseView as! AdvertiseView
    }
    
    override func awakeFromNib() {
        adImageView.isUserInteractionEnabled = true
        adImageView.contentMode = .scaleAspectFill
        adImageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushToAdvertise))
        adImageView.addGestureRecognizer(tap)
        
        countDownButton.setTitle("跳过3s", for: .normal)
        countDownButton.backgroundColor = SLColor(38, g: 38, b: 38, a: 0.6)
        countDownButton.layer.cornerRadius = 4.0
        countDownButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    //MARK: - 跳转广告详情页
    func pushToAdvertise() {
        //  1. 移除广告视图
        dismiss()
        
        // 2. 通知首页控制器push到广告详情页
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AdvertisePushNotification), object: nil)
    }
    
    //MARK: - 显示广告页面
    func show() {
        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
        let filePath = ADFileManager.getFilePath(imageName: UserDefaults.standard.value(forKey: "adImageName") as? String)
        if (filePath == nil) {
            // 2.无论沙盒是否存在广告图片，都需要重新调用广告接口，判断是否有新广告
            getRemoteAdvertiseImage()
            return
        }
        
        if ADFileManager.isFileExistWithFilePath(filePath: filePath!) {
            // 指定图片路径
            self.filePath = filePath
            
            // 倒计时方法
            startCountDown()
    
            //添加广告页面
            let window = UIApplication.shared.keyWindow
            window?.addSubview(self)
        }
        
        // 2.无论沙盒是否存在广告图片，都需要重新调用广告接口，判断是否有新广告
        getRemoteAdvertiseImage()
    }
    
    //MARK: - 获取远程图片 判断是否更新
    func getRemoteAdvertiseImage() {
        // TODO: 请求广告图
        
        //这里用一些固定的图片url模拟一下
        let imageUrl = "http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg"
        
        // 获取图片名:43-130P5122Z60-50.jpg
        let stringArr = imageUrl.components(separatedBy: "/")
        let imageName = stringArr.last!
        // 拼接沙盒路径
        let filePath = ADFileManager.getFilePath(imageName: imageName)
        let isExist =  ADFileManager.isFileExistWithFilePath(filePath: filePath!)
        if (!isExist) {// 如果该图片不存在，下载新图片,下载保存成功则删除老图片，
            downloadADImage(byUrl: imageUrl, imageName: imageName)
        }

    }
    
    func downloadADImage(byUrl: String, imageName: String) {
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: URL(string: byUrl)!)
            let image = UIImage(data: data)
            
            // 保存图片 如果是新图片 保存后删除老图片
            // 怎么保存到文件？
            let filePath = ADFileManager.getFilePath(imageName: imageName)
            if (image != nil) {
                do {
                    try UIImagePNGRepresentation(image!)!.write(to: URL(fileURLWithPath:filePath!))
                    print("保存成功")
                    // 删除旧广告
                    ADFileManager.deleteOldImage()
                    
                    // 保存新广告
                    ADFileManager.saveImage(imageName:imageName)
                } catch let error as NSError {
                    print("Error: \(error.domain)")
                }
            }
        }
    }
    
    //MARK: - 隐藏广告页面
    func dismiss()  {
        UIView.animate(withDuration: 0.3, animations: { 
                self.alpha = 0
            }) { (finished) in
                self.removeFromSuperview()
        }
    }
    
    func startCountDown() {
        count = 3
        RunLoop.main.add(self.countTimer!, forMode: .commonModes)
    }
 
}
