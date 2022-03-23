//
//  TrayWindowController.swift
//  Portal
//
//  Created by wang ya on 2020/5/28.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

class TrayWindowController: NSWindowController, TrayContainerViewDragDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.level = NSWindow.Level.popUpMenu
    }

    public func show() {
        showWindow(nil)
    }

    public func hide() {
        window?.close()
        close()
    }

    // MARK: TrayContainerViewDragDelegate

    func performDragOperation(draggingInfo: NSDraggingInfo) -> Bool {
        if let URL = draggingInfo.getDraggingURL() {
            // 播放窗口
            let webViewWindowController = WebViewWindowController(URL: URL)
            webViewWindowController.showWindow(nil)

            // 关掉托盘窗口
            hide()

            // 激活当前app
            NSApplication.shared.activate(ignoringOtherApps: true)
            return true
        }
        return false
    }
}
