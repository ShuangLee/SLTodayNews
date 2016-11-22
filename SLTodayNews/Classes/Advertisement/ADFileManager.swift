//
//  ADFileManager.swift
//  SLTodayNews
//
//  Created by 浮生若梦 on 2016/11/14.
//  Copyright © 2016年 Ls. All rights reserved.
//

import UIKit

class ADFileManager {
    //MARK: - 根据图片名拼接文件路径
    class func getFilePath(imageName: String?) -> String?{
        if imageName != nil {
             return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!.appending(imageName!)
        }
       
        return nil
    }
    
    
    //MARK: - 判断文件是否存在
    class func isFileExistWithFilePath(filePath: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: filePath)
    }
    
    //MARK: - 保存图片
    class func saveImage(imageName: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(imageName, forKey: "adImageName")
        userDefault.synchronize()
    }
    
    //MARK: -  删除旧图片
    class func deleteOldImage() {
        let imageName = UserDefaults.standard.value(forKey: "adImageName")
        if imageName != nil {
            let filePath = getFilePath(imageName: imageName as? String)
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: filePath!))
                print("删除旧图片成功。")
            } catch let error as NSError {
                print("delete image error:\(error.code)")
            }
        }
    }
}
