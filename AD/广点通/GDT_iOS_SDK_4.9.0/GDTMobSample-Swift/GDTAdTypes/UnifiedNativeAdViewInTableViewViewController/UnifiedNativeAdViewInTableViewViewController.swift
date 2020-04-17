//
//  UnifiedNativeAdViewInTableViewViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/12/11.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdViewInTableViewViewController: UIViewController,GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate,UITableViewDataSource,UITableViewDelegate {
    var tableView: UITableView!
    var placementId: String!
    var unifiedNativeAd: GDTUnifiedNativeAd!
    var dataArray: Array<GDTUnifiedNativeAdDataObject>!
    let normalCellHeight: CGFloat = 100
    let adCellHeight: CGFloat = 250
    let threeImageAdHeight: CGFloat = 120
    public var shouldMuteOnVideo: Bool!
    public var playVideoOnWWAN: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.loadAd()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTableView() {
        let marginTop: CGFloat = isIPhoneXSeries() ? 88 : 64
        self.tableView = UITableView.init()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "splitnativeexpresscell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.view.addConstraints([
            NSLayoutConstraint.init(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: marginTop),
            NSLayoutConstraint.init(item: self.tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: self.tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
            ])
    }
    
    func loadAd() {
        self.unifiedNativeAd = GDTUnifiedNativeAd.init(appId: Constant.appID, placementId: self.placementId)
        self.unifiedNativeAd.delegate = self
        self.unifiedNativeAd.load()
    }
    
    // MARK:UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.dataArray != nil else {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 10 == 5 {
            let dataObject: GDTUnifiedNativeAdDataObject = self.dataArray[0]
            return dataObject.isThreeImgsAd ? threeImageAdHeight : adCellHeight
        }
        return normalCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row % 10 == 5 {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "cellVideoID")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellVideoID")
                cell.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: adCellHeight)
                cell.selectionStyle = .none
                
                let dataObject: GDTUnifiedNativeAdDataObject = self.dataArray[0]
                
                if dataObject.isThreeImgsAd {
                    self.configCellWithThreeImgsAdRelatedViews(dataObject, cell: cell)
                } else if (dataObject.isVideoAd) {
                    self.configCellWithVideoAdRelatedViews(dataObject, cell: cell)
                } else {
                    self.configCellWithImageAdRelatedViews(dataObject, cell: cell)
                }
            }
        } else {
            cell = self.tableView .dequeueReusableCell(withIdentifier: "splitnativeexpresscell")
            if cell == nil {
                cell = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: normalCellHeight))
            }
            cell.textLabel?.text = "TableViewCell No.\(indexPath.row)"
        }
        return cell
    }
    
    //    MARK: Business Logic
    /// 拼装三小图类型广告
    ///
    /// - Parameter dataObject: 数据对象
    func configCellWithThreeImgsAdRelatedViews(_ dataObject:GDTUnifiedNativeAdDataObject, cell: UITableViewCell) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.frame.size.width - 2*10, height: threeImageAdHeight))
        unifiedNativeAdView.delegate = self
        
        /*广告标题*/
        let txt = UILabel.init(frame: CGRect.init(x: 20, y: 5, width: 220, height: 35))
        txt.text = dataObject.title
        unifiedNativeAdView.addSubview(txt)
        
        /*广告Logo*/
        let logoView = GDTLogoView.init(frame: CGRect.init(x: unifiedNativeAdView.frame.width - 54, y: unifiedNativeAdView.frame.height - 18, width: 54, height: 18))
        unifiedNativeAdView.addSubview(logoView)
        
        
        let imageContainer = UIView.init(frame: CGRect.init(x: 0, y: 40, width: unifiedNativeAdView.frame.width, height: 176))
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
        cell.contentView.addSubview(unifiedNativeAdView)
    }
    
    /// 拼装视频类型广告
    ///
    /// - Parameter dataObject: 数据对象
    func configCellWithVideoAdRelatedViews(_ dataObject: GDTUnifiedNativeAdDataObject, cell: UITableViewCell) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.frame.size.width - 2*10, height: adCellHeight))
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
        mediaView.videoMuted = self.shouldMuteOnVideo
        mediaView.videoAutoPlayOnWWAN = self.playVideoOnWWAN
        unifiedNativeAdView.addSubview(mediaView)
        unifiedNativeAdView.register(dataObject, mediaView: mediaView, logoView: logoView, viewController: self, clickableViews: [mediaView])
        
        unifiedNativeAdView.tag = 1001
        cell.contentView.addSubview(unifiedNativeAdView)
    }
    
    func configCellWithImageAdRelatedViews(_ dataObject: GDTUnifiedNativeAdDataObject, cell: UITableViewCell) {
        let subView = self.view.viewWithTag(1001)
        if ((subView?.superview) != nil) {
            subView?.removeFromSuperview()
        }
        
        /*自渲染2.0视图类*/
        let unifiedNativeAdView = GDTUnifiedNativeAdView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.frame.size.width - 2*10, height: adCellHeight))
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
        cell.contentView.addSubview(unifiedNativeAdView)
    }
    
    //    MARK:GDTUnifiedNativeAdDelegate
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        if unifiedNativeAdDataObjects != nil {
            self.dataArray = unifiedNativeAdDataObjects
            self.tableView.reloadData()
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
    
    func gdt_unifiedNativeAdView(_ unifiedNativeAdView: GDTUnifiedNativeAdView!, playerStatusChanged status: GDTMediaPlayerStatus, userInfo: [AnyHashable : Any]! = [:]) {
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
    
}
