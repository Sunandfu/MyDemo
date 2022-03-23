//
//  WebViewController.swift
//  Portal
//
//  Created by wang ya on 2020/6/1.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController {

    private var requestURL: URL?

    @IBOutlet weak var webView: WKWebView!

    convenience init(URL: URL?) {
        self.init(nibName: "WebViewController", bundle: nil)
        self.requestURL = URL
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        load(requestURL)
    }

    private func load(_ URL: URL?) {
        guard let URL = URL else { return }
        let request = URLRequest(url: URL)
        webView.load(request)
    }
    
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.window?.title = webView.title ?? ""
        PipManager.makePip(for: webView)
    }
    
}
