//
//  MNVideo.swift
//  DBMeinv
//
//  Created by Lorwy on 2017/11/24.
//  Copyright © 2017年 Lorwy. All rights reserved.
//

import UIKit

// 存放视频信息的类
class MNVideo: NSObject {
    var thumbnailUrl: String = ""
    var userPhotoUrl: String = ""
    var title = ""
    var videoUrl = ""
    
    
    
    class func video(thumurl:String,userUrl:String, title:String, vUrl:String) -> MNVideo {
        let video:MNVideo = MNVideo()
        video.thumbnailUrl = thumurl
        video.userPhotoUrl = userUrl
        video.title = title
        video.videoUrl = vUrl;
        return video
    }
}
