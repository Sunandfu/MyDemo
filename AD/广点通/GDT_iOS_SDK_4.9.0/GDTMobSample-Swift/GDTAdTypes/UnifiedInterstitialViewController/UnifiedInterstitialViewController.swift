//
//  UnifiedInterstitialViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2019/3/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedInterstitialViewController: UIViewController,GDTUnifiedInterstitialAdDelegate {
    
    @IBOutlet weak var interstitialStateLabel: UILabel!
    @IBOutlet weak var positionIDTextField: UITextField!
    private var interstitial: GDTUnifiedInterstitialAd?
    private let INTERSTITIAL_STATE_TEXT = "插屏状态"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func loadAd(_ sender: Any) {
        if (interstitial != nil) {
            interstitial?.delegate = nil
            interstitial = nil
        }
        interstitial = GDTUnifiedInterstitialAd.init(appId: Constant.appID, placementId: positionIDTextField.text!)
        interstitial?.delegate = self
        
        interstitial?.load()
    }
    
    @IBAction func showAd(_ sender: Any) {
        interstitial?.present(fromRootViewController: self)
    }
    
    func unifiedInterstitialSuccess(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): load successfully."
    }
    
    func unifiedInterstitialFail(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd, error: Error) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): load error."
    }
    
    func unifiedInterstitialWillPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): is going to present."
    }
    
    func unifiedInterstitialDidPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): successfully presented."
    }
    
    func unifiedInterstitialDidDismissScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): finish presenting."
    }
    
    func unifiedInterstitialWillLeaveApplication(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialWillExposure(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialClicked(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialAdWillPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialAdDidPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialAdWillDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }
    
    func unifiedInterstitialAdDidDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
        print(#function)
    }

}
