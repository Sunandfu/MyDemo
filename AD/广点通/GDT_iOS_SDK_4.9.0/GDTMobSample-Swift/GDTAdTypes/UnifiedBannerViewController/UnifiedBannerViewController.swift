//
//  UnifiedBannerViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2019/3/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedBannerViewController: UIViewController, GDTUnifiedBannerViewDelegate {

    @IBOutlet weak var placementTextField: UITextField!
    private var bannerView:GDTUnifiedBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }
    
    func loadAd() {
        initMobBannerView()
        self.view.addSubview(bannerView)
        self.bannerView.loadAdAndShow()
        
    }
    
    func initMobBannerView() {
        if bannerView == nil {
            let rect = CGRect.init(origin: .zero, size:CGSize.init(width: 375, height: 60))
            bannerView = GDTUnifiedBannerView.init(frame: rect, appId: Constant.appID, placementId: placementTextField.text!, viewController: self)
            bannerView.delegate = self
        }
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
    
    func unifiedBannerViewDidLoad(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
    }
    
    func unifiedBannerViewFailed(toLoad unifiedBannerView: GDTUnifiedBannerView, error: Error) {
        print(#function)
        
    }
    
    func unifiedBannerViewWillExpose(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewClicked(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewWillPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewDidPresentFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewWillDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewDidDismissFullScreenModal(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewWillLeaveApplication(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
    
    func unifiedBannerViewWillClose(_ unifiedBannerView: GDTUnifiedBannerView) {
        print(#function)
        
    }
}
