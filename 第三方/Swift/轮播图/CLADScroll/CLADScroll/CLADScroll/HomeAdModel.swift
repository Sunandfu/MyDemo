//
//  HomeAdModel.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit

class HomeAdModel: NSObject {
    var Path: String?
    var Title2: String?
    var Title: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        Path = dict["Path"] as? String ?? ""    // 如果为空就转为“”
        Title2 = dict["Title2"] as? String ?? ""
        Title = dict["Title"] as? String ?? ""
    }
    

}
