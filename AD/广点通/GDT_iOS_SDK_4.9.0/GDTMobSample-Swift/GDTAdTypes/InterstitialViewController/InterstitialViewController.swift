//
//  InterstitialViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class InterstitialViewController: UIViewController,GDTMobInterstitialDelegate {

    @IBOutlet weak var interstitialStateLabel: UILabel!
    @IBOutlet weak var positionIDTextField: UITextField!
    private var interstitial: GDTMobInterstitial?
    private let INTERSTITIAL_STATE_TEXT = "插屏状态"
    override func viewDidLoad() {
        super.viewDidLoad()
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
        interstitial = GDTMobInterstitial.init(appId: Constant.appID, placementId: positionIDTextField.text)
        interstitial?.delegate = self
        
        interstitial?.loadAd()
    }
    
    @IBAction func showAd(_ sender: Any) {
        interstitial?.present(fromRootViewController: self)
    }
    
//    MARK:GDTMobInterstitialDelegate
    func interstitialSuccess(toLoadAd interstitial: GDTMobInterstitial!) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): load successfully."
    }
    
    func interstitialWillPresentScreen(_ interstitial: GDTMobInterstitial!) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): is going to present."
    }
    
    func interstitialDidPresentScreen(_ interstitial: GDTMobInterstitial!) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): successfully presented."
    }
    
    func interstitialDidDismissScreen(_ interstitial: GDTMobInterstitial!) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): finish presenting."
    }

    func interstitialApplicationWillEnterBackground(_ interstitial: GDTMobInterstitial!) {
        interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): application will enter background."
    }
}
