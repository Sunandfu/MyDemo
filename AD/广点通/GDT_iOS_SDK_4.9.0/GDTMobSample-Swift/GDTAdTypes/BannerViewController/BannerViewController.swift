//
//  BannerViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//
import UIKit

class BannerViewController: UIViewController,GDTMobBannerViewDelegate {
    
    @IBOutlet weak var placemengIdText: UITextField!
    @IBOutlet weak var refreshIntervalText: UITextField!
    @IBOutlet weak var gpsSwitch: UISwitch!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var closeBtnSwitch: UISwitch!
    
    private var bannerView:GDTMobBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()        
    }
    
    func initMobBannerView() {
        if bannerView == nil {
            let rect = CGRect.init(origin: .zero, size:CGSize.init(width: 320, height: 50))
            bannerView = GDTMobBannerView.init(frame: rect, appId: Constant.appID, placementId: placemengIdText.text)
            bannerView.currentViewController = self
            bannerView.interval = Int32(refreshIntervalText.text!)!
            bannerView.isAnimationOn = animationSwitch.isOn
            bannerView.showCloseBtn = closeBtnSwitch.isOn
            bannerView.isGpsOn = gpsSwitch.isOn
            bannerView.delegate = self
        }
    }
    
    func loadAd() {
        initMobBannerView()
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let viewConstraints:[NSLayoutConstraint] = [
            NSLayoutConstraint.init(item: bannerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
                                                NSLayoutConstraint.init(item: bannerView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
                                                NSLayoutConstraint.init(item: bannerView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)]
        self.view.addConstraints(viewConstraints)
        
        let bannerConstraints:[NSLayoutConstraint] = [
            NSLayoutConstraint.init(item: bannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)]
        self.bannerView.addConstraints(bannerConstraints)
        self.bannerView.loadAdAndShow()
  
    }
    
    private func removeAdFromSuperview() {
        if let view = bannerView {
            view.removeFromSuperview()
            bannerView = nil
        }
    }

    @IBAction func showAd(_ sender: Any) {
        removeAdFromSuperview()
        loadAd()
    }
    
    @IBAction func removeAd(_ sender: Any) {
        removeAdFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //    MARK:GDTMobBannerViewDelegate
    func bannerViewDidReceived() {
        print("banner Received")
    }
    
    func bannerViewFail(toReceived error: Error!) {
        print("banner failed to Receive: \(error)")
    }
    
    func bannerViewClicked() {
        print("banner clicked")
    }
    
    func bannerViewWillLeaveApplication() {
        print("banner will leave application")
    }
    
    func bannerViewWillDismissFullScreenModal() {
        print(#function)
    }
    
    func bannerViewDidDismissFullScreenModal() {
        print(#function)
    }
    
    func bannerViewWillPresentFullScreenModal() {
        print(#function)
    }
    
    func bannerViewDidPresentFullScreenModal() {
        print(#function)
    }
}
