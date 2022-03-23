//
//  DefaultWebViewController.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/22.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit
import PullToRefreshKit

class DefaultWebViewController: UIViewController,UIWebViewDelegate{
    var webview:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview = UIWebView(frame:view.bounds)
        self.webview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.webview.backgroundColor = UIColor.white
        view.addSubview(self.webview)
        self.webview.scrollView.configRefreshHeader(container:self) {
            if self.webview.request != nil{
                self.webview.reload()
            }else{
                let url = URL(string: "https://www.baidu.com")
                let request = URLRequest(url: url!)
                self.webview.loadRequest(request)
            }
        };
        let url = URL(string: "https://www.baidu.com")
        let request = URLRequest(url: url!)
        self.webview.loadRequest(request)
        self.webview.delegate = self
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webview.scrollView.switchRefreshHeader(to: .normal(.success, 0.5))
    }
}
