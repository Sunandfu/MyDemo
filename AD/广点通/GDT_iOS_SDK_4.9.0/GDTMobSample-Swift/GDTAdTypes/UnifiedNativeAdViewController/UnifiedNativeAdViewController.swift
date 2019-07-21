//
//  UnifiedNativeAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/11/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdViewController: UIViewController,GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate {
    @IBOutlet weak var placementTextField: UITextField!
    @IBOutlet weak var shouldMuteOnVideoSwitch: UISwitch!
    @IBOutlet weak var playVideoOnWWANSwitch: UISwitch!
    var unifiedNativeAd: GDTUnifiedNativeAd!
    var dataArray: Array<GDTUnifiedNativeAdDataObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func loadUnifiedNativeAd(_ sender: Any) {
        unifiedNativeAd = GDTUnifiedNativeAd.init(appId: Constant.appID, placementId: placementTextField.text)
        unifiedNativeAd.delegate = self
        unifiedNativeAd .loadAd(withAdCount: 1)
    }

    @IBAction func loadUnifiedNativeAdInTableView(_ sender: Any) {
        let vc = UnifiedNativeAdViewInTableViewViewController.init(nibName: "UnifiedNativeAdViewInTableViewViewController", bundle: nil)
        vc.placementId = self.placementTextField.text
        vc.shouldMuteOnVideo = self.shouldMuteOnVideoSwitch.isOn
        vc.playVideoOnWWAN = self.playVideoOnWWANSwitch.isOn
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 拼装三小图类型广告
    ///
    /// - Parameter dataObject: 数据对象
    func setThreeImgsAdRelatedViews(_ dataObject:GDTUnifiedNativeAdDataObject) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 180, width: self.view.frame.size.width - 2*10, height: 120))
        unifiedNativeAdView.delegate = self
        
        /*广告标题*/
        let txt = UILabel.init(frame: CGRect.init(x: 20, y: 5, width: 220, height: 35))
        txt.text = dataObject.title
        unifiedNativeAdView.addSubview(txt)
        
        /*广告Logo*/
        let logoView = GDTLogoView.init(frame: CGRect.init(x: unifiedNativeAdView.frame.width - 54, y: unifiedNativeAdView.frame.height - 18, width: 54, height: 18))
        unifiedNativeAdView.addSubview(logoView)
        
        
        let imageContainer = UIView.init(frame: CGRect.init(x: 0, y: 70, width: unifiedNativeAdView.frame.width, height: 176))
        let imageView1 = UIImageView.init(frame: CGRect.init(x: 20, y: 0, width: 100, height: 70))
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: URL.init(string: dataObject.mediaUrlList?[0] as! String)!)
            guard let image1Data = optData else {
                return
            }
            DispatchQueue.main.async {
                imageView1.image = UIImage.init(data: image1Data)
            }
        }
        imageContainer.addSubview(imageView1)
        
        let imageView2 = UIImageView.init(frame: CGRect.init(x: 130, y: 0, width: 100, height: 70))
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: URL.init(string: dataObject.mediaUrlList?[1] as! String)!)
            guard let image2Data = optData else {
                return
            }
            DispatchQueue.main.async {
                imageView2.image = UIImage.init(data: image2Data)
            }
        }
        imageContainer.addSubview(imageView2)
        
        let imageView3 = UIImageView.init(frame: CGRect.init(x: 240, y: 0, width: 100, height: 70))
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: URL.init(string: dataObject.mediaUrlList?[2] as! String)!)
            guard let image3Data = optData else {
                return
            }
            DispatchQueue.main.async {
                imageView3.image = UIImage.init(data: image3Data)
            }
        }
        imageContainer.addSubview(imageView3)
        
        unifiedNativeAdView.addSubview(imageContainer)
        unifiedNativeAdView.register(dataObject, logoView: logoView, viewController: self, clickableViews: [imageContainer])
        
        unifiedNativeAdView.tag = 1001
        self.view.addSubview(unifiedNativeAdView)
    }
    
    /// 拼装视频类型广告
    ///
    /// - Parameter dataObject: 数据对象
    func setupVideoAdRelatedViews(_ dataObject: GDTUnifiedNativeAdDataObject) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 180, width: self.view.frame.size.width - 2*10, height: 250))
        unifiedNativeAdView.delegate = self
        
        /*广告标题*/
        let txt = UILabel.init(frame: CGRect.init(x: 80, y: 5, width: 220, height: 35))
        txt.text = dataObject.title
        unifiedNativeAdView.addSubview(txt)
        
        /*广告Logo*/
        let logoView = GDTLogoView.init(frame: CGRect.init(x: unifiedNativeAdView.frame.width - 54, y: unifiedNativeAdView.frame.height - 23, width: 54, height: 18))
        unifiedNativeAdView.addSubview(logoView)
        
        let iconV = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 60, height: 60))
        let iconURL = URL.init(string: dataObject.iconUrl as! String)!
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: iconURL)
            guard let iconData = optData else {
                return
            }
            DispatchQueue.main.async {
                iconV.image = UIImage.init(data: iconData)
            }
        }
        unifiedNativeAdView.addSubview(iconV)
        
        let desc = UILabel.init(frame: CGRect.init(x: 80, y: 45, width: 230, height: 20))
        desc.text = dataObject.desc
        unifiedNativeAdView.addSubview(desc)
        
        let mediaView = GDTMediaView.init(frame: CGRect.init(x: 0, y: 70, width: unifiedNativeAdView.frame.width, height: 176))
        mediaView.videoMuted = self.shouldMuteOnVideoSwitch.isOn
        mediaView.videoAutoPlayOnWWAN = self.playVideoOnWWANSwitch.isOn
        unifiedNativeAdView.addSubview(mediaView)
        unifiedNativeAdView.register(dataObject, mediaView: mediaView, logoView: logoView, viewController: self, clickableViews: [mediaView])
        
        unifiedNativeAdView.tag = 1001
        self.view.addSubview(unifiedNativeAdView)
    }
    
    func setupImageAdRelatedViews(_ dataObject: GDTUnifiedNativeAdDataObject) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 180, width: self.view.frame.size.width - 2*10, height: 250))
        unifiedNativeAdView.delegate = self
        
        /*广告标题*/
        let txt = UILabel.init(frame: CGRect.init(x: 80, y: 5, width: 220, height: 35))
        txt.text = dataObject.title
        unifiedNativeAdView.addSubview(txt)
        
        /*广告Logo*/
        let logoView = GDTLogoView.init(frame: CGRect.init(x: unifiedNativeAdView.frame.width - 54, y: unifiedNativeAdView.frame.height - 23, width: 54, height: 18))
        unifiedNativeAdView.addSubview(logoView)
        
        let iconV = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 60, height: 60))
        let iconURL = URL.init(string: dataObject.iconUrl as! String)!
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: iconURL)
            guard let iconData = optData else {
                return
            }
            DispatchQueue.main.async {
                iconV.image = UIImage.init(data: iconData)
            }
        }
        unifiedNativeAdView.addSubview(iconV)
        
        let desc = UILabel.init(frame: CGRect.init(x: 80, y: 45, width: 230, height: 20))
        desc.text = dataObject.desc
        unifiedNativeAdView.addSubview(desc)
        
        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 70, width: unifiedNativeAdView.frame.width, height: 176))
        DispatchQueue.global(qos: .background).async {
            let optData = try? Data(contentsOf: URL.init(string: dataObject.imageUrl as! String)!)
            guard let imageData = optData else {
                return
            }
            DispatchQueue.main.async {
                imgV.image = UIImage.init(data: imageData)
            }
        }
        unifiedNativeAdView.addSubview(imgV)
        
        unifiedNativeAdView.register(dataObject, logoView: logoView, viewController: self, clickableViews: [imgV])
        unifiedNativeAdView.tag = 1001
        self.view.addSubview(unifiedNativeAdView)
    }
    
    func gdt_unifiedNativeAdViewWillExpose(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print("广告被曝光")
    }
    
    func gdt_unifiedNativeAdViewDidClick(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print("广告被点击")
    }
    
    func gdt_unifiedNativeAdDetailViewClosed(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print("广告详情页已关闭")
    }
    
    func gdt_unifiedNativeAdViewApplicationWillEnterBackground(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print("广告进入后台")
    }
    
    func gdt_unifiedNativeAdDetailViewWillPresentScreen(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print("广告详情页面即将打开")
    }
    
    func gdt_unifiedNativeAdView(_ nativeExpressAdView: GDTUnifiedNativeAdView!, playerStatusChanged status: GDTMediaPlayerStatus, userInfo: [AnyHashable : Any]! = [:]) {
        print("视频广告状态变更")
        switch status {
        case .initial:
            print("视频初始化")
        case .loading:
            print("视频加载中")
        case .started:
            print("视频开始播放")
        case .paused:
            print("视频暂停")
        case .stoped:
            print("视频停止")
        case .error:
            print("视频播放出错")
        default:
            break
        }
        if userInfo != nil {
            let videoDuration: CGFloat = userInfo?[kGDTUnifiedNativeAdKeyVideoDuration] as! CGFloat
            print("视频广告长度为\(videoDuration)")
        }
    }
    
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        if let dataObject = unifiedNativeAdDataObjects?[0] {
            print("请求到广告数据")
            if dataObject.isThreeImgsAd {
                self.setThreeImgsAdRelatedViews(dataObject)
            } else if dataObject.isVideoAd {
                self.setupVideoAdRelatedViews(dataObject)
            } else {
                self.setupImageAdRelatedViews(dataObject)
            }
            if let err = error {
                let code = (error as! NSError).code
                if code == 5004 {
                    print("没匹配的广告，禁止重试，否则影响流量变现效果");
                } else if code == 5005 {
                    print("流量控制导致没有广告，超过日限额，请明天再尝试");
                } else if code == 5009 {
                    print("流量控制导致没有广告，超过小时限额");
                } else if code == 5006 {
                    print("包名错误");
                } else if code == 5010 {
                    print("广告样式校验失败");
                } else if code == 3001 {
                    print("网络错误");
                } else {
                    print("\(String(describing: error))");
                }
            }

        }
    }
}
