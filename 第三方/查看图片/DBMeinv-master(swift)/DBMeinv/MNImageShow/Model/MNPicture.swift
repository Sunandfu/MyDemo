//
//  MNPicture.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/22.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit

class MNPicture: NSObject {

}

// 存放图片信息的类
class PhotoInfo: NSObject {
    var forumUrl: String = ""
    var imageUrl: String = ""
    var bigImageUrl: String {
        get {
            return imageUrl.replacingOccurrences(of: "bmiddle", with: "large")
        }
    }
    
    var imageSize: CGSize = CGSize(width: 0.0, height: 0.0)
    var title = ""
    
    
    class func photo(url:String, title:String) -> PhotoInfo {
        let photo:PhotoInfo = PhotoInfo()
        photo.imageUrl = url
        photo.title = title
        return photo
    }
}

enum PageType:String {
    case daxiong    = "2"  // 1
    case qiaotun    = "6"  // 2
    case heisi      = "7"    // 3
    case meitui     = "3"   // 4
    case yanzhi     = "4"   // 5
    case dazzhui    = "5"  // 6
}

// 工具函数
class MNPictureUtil {
    
    static func selectTypeByNumber(number: Int) -> PageType {
        switch number {
        case 0:
            return .daxiong
        case 1:
            return .qiaotun
        case 2:
            return .heisi
        case 3:
            return .meitui
        case 4:
            return .yanzhi
        case 5:
            return .dazzhui
        default:
            return .daxiong
        }
    }
}
