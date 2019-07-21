//
//  NativeViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class NativeViewController: UIViewController,GDTNativeAdDelegate {

    @IBOutlet weak var posTextField: UITextField!
    @IBOutlet weak var responseTextView: UITextView!
    var nativeAd:GDTNativeAd!
    var adArray:Array<GDTNativeAdData>!
    var currentAdData:GDTNativeAdData!
    var adView:UIView!
    var attached:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func requestAd(_ sender: Any) {
        if attached {
            self.adView.removeFromSuperview()
            self.adView = nil
            attached = false
        }
        
        /*
         * 创建原生广告
         * "appId" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
         * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
         *
         * 本原生广告位ID在联盟系统中创建时勾选的详情图尺寸为1280*720，开发者可以根据自己应用的需要
         * 创建对应的尺寸规格ID
         *
         * 这里详情图以1280*720为例
         */
        self.nativeAd = GDTNativeAd.init(appId: Constant.appID, placementId: self.posTextField.text)
        self.nativeAd.controller = self
        self.nativeAd.delegate = self
        
        /*
         * 拉取广告,传入参数为拉取个数。
         * 发起拉取广告请求,在获得广告数据后回调delegate
         */
        self.nativeAd.load(1)//这里以一次拉取一条原生广告为例
    }
    
    @IBAction func renderAd(_ sender: Any) {
        if adArray.count > 0 && !attached {
            self.initAdView()
            /*选择展示广告*/
            currentAdData = adArray[0]
            
            var currentAdDict : Dictionary = Dictionary<String,String>()
            for (key,value) in currentAdData.properties {
                currentAdDict[(key as? String)!] = "\(value)"
            }
            
            /*广告详情图*/
            let imgV = UIImageView.init(frame: CGRect(x: 2, y: 70, width: 316, height: 176))
            self.adView.addSubview(imgV)
            let imageURL:URL! = URL(string: currentAdDict[GDTNativeAdDataKeyImgUrl]!)
            
            DispatchQueue.global(qos: .background).async {
                let optData = try? Data(contentsOf: imageURL! as URL)
                guard let imgData = optData else {
                    return
                }
                
                DispatchQueue.main.async {
                    imgV.image = UIImage(data: imgData)
                }
            }
            
            /*广告详情图*/
            let iconV = UIImageView.init(frame: CGRect(x: 10, y: 5, width: 60, height: 60))
            self.adView.addSubview(iconV)
            let iconURL:URL! = URL(string: currentAdDict[GDTNativeAdDataKeyIconUrl]!)
            
            DispatchQueue.global(qos: .background).async {
                let optData = try? Data(contentsOf: iconURL! as URL)
                guard let iconData = optData else {
                    return
                }
                
                DispatchQueue.main.async {
                    iconV.image = UIImage(data: iconData)
                }
            }
            
            /*广告标题*/
            let txt = UILabel.init(frame: CGRect(x: 80, y: 5, width: 220, height: 35))
            txt.text = currentAdDict[GDTNativeAdDataKeyTitle]
            self.adView.addSubview(txt)
            
            /*广告描述*/
            let desc = UILabel.init(frame: CGRect(x: 80, y: 45, width: 220, height: 20))
            desc.text = currentAdDict[GDTNativeAdDataKeyDesc]
            self.adView.addSubview(desc)
            
            var adViewFrame = adView.frame
            adViewFrame.origin.x = UIScreen.main.bounds.size.width + adViewFrame.origin.x
            adView.frame = adViewFrame
            
            self.view.addSubview(adView)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewTapped))
            adView.addGestureRecognizer(tap)
            
            UIView.animate(withDuration: 0.5) {
                self.adView.center = self.responseTextView.center;
            }
            
            nativeAd.attach(currentAdData, to: adView)
            attached = true
        } else if attached {
            responseTextView.text = "Already attached"
        } else {
            responseTextView.text = "原生广告数据拉取失败，无法Attach"
        }
    }
    
    @objc func viewTapped() {
        nativeAd.click(currentAdData)
    }
    
    //    MARK:GDTNativeAdDelegate
    func nativeAdSuccess(toLoad nativeAdDataArray: [Any]!) {
        print(#function)
        self.adArray = nativeAdDataArray as! Array<GDTNativeAdData>
        DispatchQueue.main.async {
            var result = ""
            result.append("原生广告返回数据：\n")
            for data:GDTNativeAdData in self.adArray {
                result = result.appendingFormat("{ \n")
                for (key,value) in data.properties {
                    result = result.appendingFormat("  \((key as? String)!) = \(value) \n")
                }
                result = result.appendingFormat("}")
                result = result.appendingFormat("\nisAppAd:%@", data.isAppAd() ? "YES" : "NO")
                 result = result.appendingFormat("\nisThreeImagesAd:%@", data.isThreeImgsAd() ? "YES" : "NO")
                result.append("\n--------------------------------")
            }
            self.responseTextView.text = result
        }
    }
    
    func nativeAdFail(toLoad error: Error!) {
        print(error)
        self.currentAdData = nil
        DispatchQueue.main.async {
            self.responseTextView.text = "原生广告数据拉取失败，\(error)"
        }
    }
    
    private func initAdView() {
        adView = UIView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 260))
        adView.center = self.responseTextView.center
        adView.layer.borderWidth = 1
        adView.backgroundColor = .white
    }
}
