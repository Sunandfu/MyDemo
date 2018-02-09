//
//  LSYSwiftDefine.swift
//  AlbumPicker
//
//  Created by okwei on 15/8/4.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

import Foundation
import UIKit
public class LSYSwiftDefine {
    public class func DistanceFromTopGuiden(view:AnyObject?)->CGFloat{
        return (view?.frame.origin.y)! + (view?.frame.size.height)!
    }
    
    public class func DistanceFromLeftGuiden(view:AnyObject?)->CGFloat{
        return(view?.frame.origin.x)! + (view?.frame.size.width)!
    }
    public class func ViewOrigin(view:AnyObject?)->CGPoint{
        return(view?.frame.origin)!
    }
    public class func ViewSize(view:AnyObject?)->CGSize{
        return(view?.frame.size)!
    }
}