//
//  MNPictureCategoryViewModel.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/22.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

private let imageBaseUrl = "http://www.dbmeinv.com/dbgroup/rank.htm?pager_offset="
private let pageBaseUrl = "http://www.dbmeinv.com/dbgroup/show.htm?cid="

class MNPictureCategoryViewModel: NSObject {
    
    var photos = NSMutableOrderedSet()  //一个有序的可变集合
    
    var populatingPhotos = false   // 是否在获取图片
    var currentPage = 1
    var isloadMore = false
    
    
    var populateSuccess = false
    
    
    var currentType:PageType = .daxiong
    
    
    /// 返回当前请求url
    ///
    /// - Returns: pageurl
    func getPageUrl()-> String {
        return pageBaseUrl + currentType.rawValue + "&pager_offset=" + "\(currentPage)"
    }

    // MARK: - 当前选中类型发生变化
    func selectIndexDidChanged(index: Int) {
        currentType = MNPictureUtil.selectTypeByNumber(number: index - 1)
        populatePhotos(loadMore: false)
    }
    
    //MARK - 网络获取信息
    func populatePhotos(loadMore: Bool) {
        if populatingPhotos { //正在获取，则返回
            print("getting now return back")
            return
        }
        self.isloadMore = loadMore
        if loadMore {
            self.currentPage += 1
        } else {
            self.currentPage = 1
        }
        // 标记正在获取，其他线程来则返回
        populatingPhotos = true
        populateSuccess = false
        let pageUrl = getPageUrl()
        Alamofire.request(pageUrl).responseString { response in
            print("Success: \(response.result.isSuccess)")
            let isSuccess = response.result.isSuccess
            let html = response.result.value
            
            if isSuccess == true {
                self.populateSuccess = true
                let queue = DispatchQueue(label:"com.lorwy.myqueue")
                queue.async {
                    //用photos保存临时数据
                    let datas = NSMutableOrderedSet()
                    //用kanna解析html数据
                    if let doc = try? Kanna.HTML(html: html!, encoding: String.Encoding.utf8) {
                        CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                        //解析imageurl
                        for node in doc.css("img") {
                            if self.checkString(string:node["src"]) &&
                                self.checkString(string:node["title"]) {
                                let img : String = node["src"]!
                                let title = node["title"]!
                                let itemInfo:PhotoInfo = PhotoInfo.photo(url:img, title:title)
                                datas.add(itemInfo)
                            }
                        }
                        if self.isloadMore { // 加载更多
                            self.photos.addObjects(from: datas.array)
                        } else {
                            self.photos = datas
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("populatePhotoshttp"), object: nil)
                }
            }else{
                self.populateSuccess = false
                NotificationCenter.default.post(name: NSNotification.Name("populatePhotoshttp"), object: nil)
            }
            self.populatingPhotos = false;
        }
    }

    // 检查image url，必须符合某种给定规则
    func checkString(string: String?) -> Bool {
        if string == nil {
            return false
        }
        return true
    }
}
