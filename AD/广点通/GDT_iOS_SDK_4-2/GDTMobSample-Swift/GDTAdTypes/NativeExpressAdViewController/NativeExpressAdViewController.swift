//
//  NativeExpressAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class NativeExpressAdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GDTNativeExpressAdDelegete {

    private var expressAdViews:Array<GDTNativeExpressAdView>!
    private var nativeExpressAd:GDTNativeExpressAd!
    
    @IBOutlet weak var placementIdTextField: UITextField!
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var adCountSlider: UISlider!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var adCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        widthSlider.value = Float(UIScreen.main.bounds.size.width)
        heightSlider.value = 50
        adCountSlider.value = 3
        
        let widthStr = String(format:"%.0f",widthSlider.value)
        widthLabel.text = "宽：\(widthStr)"
        let heightStr = String(format: "%.0f", heightSlider.value)
        heightLabel.text = "高：\(heightStr)"
        let countStr = String(format: "%.0f", adCountSlider.value)
        adCountLabel.text = "count：\(countStr)"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nativeExpressAd = GDTNativeExpressAd.init(appId: Constant.appID, placementId: placementIdTextField.text, adSize: CGSize(width: Int(widthSlider.value), height: Int(heightSlider.value)))
        
        nativeExpressAd.delegate = self
        nativeExpressAd.load(Int(adCountSlider.value))
        
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "nativeexpresscell")
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "splitnativeexpresscell")
        
    }
    @IBAction func sliderPositionWChanged(_ sender: Any) {
        let widthStr = String(format:"%.0f",widthSlider.value)
        widthLabel.text = "宽：\(widthStr)"
    }
    
    @IBAction func sliderPositionHChanged(_ sender: Any) {
        let heightStr = String(format: "%.0f", heightSlider.value)
        heightLabel.text = "高：\(heightStr)"
    }
    
    @IBAction func sliderPositionCountChanged(_ sender: Any) {
        let countStr = String(format: "%.0f", adCountSlider.value)
        adCountLabel.text = "count：\(countStr)"
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        nativeExpressAd = GDTNativeExpressAd.init(appId: Constant.appID, placementId: placementIdTextField.text, adSize: CGSize(width: Int(widthSlider.value), height: Int(heightSlider.value)))
        
        nativeExpressAd.delegate = self
        nativeExpressAd.load(Int(adCountSlider.value))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //    Mark:UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            let view: UIView = expressAdViews[indexPath.row/2]
            return view.bounds.size.height
        }
        return 44
    }
    
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (expressAdViews != nil) ? expressAdViews.count * 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "nativeexpresscell", for: indexPath)
            cell.selectionStyle = .none
            
            let subView: UIView? = cell!.contentView.viewWithTag(1000)
            if (subView?.superview != nil) {
                subView?.removeFromSuperview()
            }
            
            let view: UIView = expressAdViews[indexPath.row / 2]
            view.tag = 1000
            cell.contentView.addSubview(view)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "splitnativeexpresscell", for: indexPath)
            cell.backgroundColor = .gray
        }
        
        return cell
    }
    
    //    Mark:GDTNativeExpressAdDelegete
    func nativeExpressAdSuccess(toLoad nativeExpressAd: GDTNativeExpressAd!, views: [GDTNativeExpressAdView]!) {
        expressAdViews = Array.init(views)
        if expressAdViews.count > 0 {
            for obj in expressAdViews {
                let expressView:GDTNativeExpressAdView = obj
                expressView.controller = self
                expressView.render()
            }
        }
        tableView.reloadData()
    }
    
    func nativeExpressAdFail(toLoad nativeExpressAd: GDTNativeExpressAd!, error: Error!) {
        print("Express Ad Load Fail : \(error)")
    }
    
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        tableView.reloadData()
    }
    
    func nativeExpressAdViewClicked(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        print(#function)
    }
    
    func nativeExpressAdViewClosed(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        print(#function)
        if let removeIndex = expressAdViews.index(of: nativeExpressAdView) {
            expressAdViews.remove(at: removeIndex)
            tableView.reloadData()
        }
    }
}
