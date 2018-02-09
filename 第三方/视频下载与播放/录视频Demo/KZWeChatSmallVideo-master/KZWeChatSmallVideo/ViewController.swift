//
//  ViewController.swift
//  KZWeChatSmallVideo
//
//  Created by HouKangzhu on 16/7/11.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class ViewController: UIViewController , KZVideoViewControllerDelegate{

    var video:KZVideoModel? = nil
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func videoAction(sender: AnyObject) {
        let videoVC = KZVideoViewController()
        videoVC.delegate = self
//        self.presentViewController(videoVC, animated: true, completion: nil)
        videoVC.startAnimation()
    }
    
    @IBAction func playAction(sender: AnyObject) {
        guard self.video != nil else {
            return
        }
    }

    func videoViewController(videoViewController: KZVideoViewController!, didRecordVideo video: KZVideoModel!) {
        self.playBtn.setBackgroundImage(UIImage(contentsOfFile: video.totalThumPath!), forState: .Normal)
        self.video = video
        self.videoView.layoutIfNeeded()
        
        for subView in self.videoView.subviews {
            subView.removeFromSuperview()
        }
        
        let player = KZVideoPlayer(frame: self.videoView.bounds, aVideoURL: NSURL(fileURLWithPath: video.totalVideoPath))
        self.videoView.addSubview(player)
    }
    
    func videoViewControllerDidCancel(videoViewController: KZVideoViewController!) {
        
    }
}

