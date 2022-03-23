//
//  WebViewWindowController.swift
//  Portal
//
//  Created by wang ya on 2020/6/1.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

class WebViewWindowController: NSWindowController {

    private var webViewController: WebViewController!

    convenience init(URL: URL?) {
        self.init(windowNibName: "WebViewWindowController")
        webViewController = WebViewController(URL: URL)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.level = NSWindow.Level.popUpMenu
        window?.contentViewController = webViewController
    }
    
}
