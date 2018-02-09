//
//  MNVideoShowViewModel.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

private let videoPageBaseUrl = "https://www.dbmeinv.com/dbgroup/videos.htm?pager_offset="

class MNVideoShowViewModel: NSObject {
    
    var videos = NSMutableOrderedSet()  //一个有序的可变集合
    var populatingVideo = false   // 是否在获取图片
    var currentPage = 1
    var isloadMore = false
    
    var populateSuccess = false
    
    func getPageUrl()-> String {
        return videoPageBaseUrl + "\(currentPage)"
    }
    
    func populateVieos(loadMore: Bool) -> Void {
        if populatingVideo { //正在获取，则返回
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
        populatingVideo = true
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
                    let datas = NSMutableOrderedSet()
                    //用kanna解析html数据
                    if let doc = try? Kanna.HTML(html: html!, encoding: String.Encoding.utf8) {
                        CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                        for node in doc.css("li[class='span3']") {
                            let modeA = node.css("a")
                            let url = modeA[0]["href"] // 视频地址
                            
                            let modeImg = node.css("img")
                            let img = modeImg[0]["src"]!// 封面地址
                            
                            let nodeUserImg = node.css("div[class='avatar'], img")
                            let userImg = nodeUserImg[0]["src"]
                            
                            // 标题
                            let nodeTitle = node.css("span[class='fl p5 meta']")
                            let title = nodeTitle[0].text
                            let b = title?.stringEscapeHeadTail(strs:["\r", "\n", "\t", "\r\n", " "])
                            
                            let itemInfo = MNVideo.video(thumurl: img, userUrl: userImg!, title: b!, vUrl: url!)
                            datas.add(itemInfo)
                        }
                        if self.isloadMore { // 加载更多
                            self.videos.addObjects(from: datas.array)
                        } else {
                            self.videos = datas
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("populateVideoshttp"), object: nil)
                }
            }else{
                self.populateSuccess = false
                NotificationCenter.default.post(name: NSNotification.Name("populateVideoshttp"), object: nil)
            }
            self.populatingVideo = false;
        }
    }
    
    // 获取视频的url
    func populateVieosUrl(targetUrl:String) {
        
        populateSuccess = false
        Alamofire.request(targetUrl).responseString { response in
            print("Success: \(response.result.isSuccess)")
            let isSuccess = response.result.isSuccess
            let html = response.result.value
            
            if isSuccess == true {
                self.populateSuccess = true
                let queue = DispatchQueue(label:"com.lorwy.myqueue")
                queue.async {
                    //用kanna解析html数据
                    var resultString = ""
                    if let doc = try? Kanna.HTML(html: html!, encoding: String.Encoding.utf8) {
                        CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingASCII)
                        for scriptNode in doc.css("script[type='text/javascript']") {
                            let scriptText = scriptNode.toHTML
                            let a = NSString(string:scriptText!)
    
                            let startRange = a.range(of: "http://gslb.miaopai.com")
                            let endRange = a.range(of: ".mp4\">")
                            if startRange.length > 0 && endRange.length > 0 {
                                resultString = a.substring(with: NSRange(location: startRange.location, length: endRange.location + endRange.length - startRange.location - 2))
                                break
                            }
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("populateVideosPlayUrlHttp"), object: resultString)
                }
            }else{
                self.populateSuccess = false
                NotificationCenter.default.post(name: NSNotification.Name("populateVideosPlayUrlHttp"), object: nil)
            }
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
