//
//  StatusItemController.swift
//  Portal
//
//  Created by wang ya on 2020/5/28.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

class StatusItemController: NSObject {
    lazy var statusItem: NSStatusItem = {
        return NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    }()

    lazy var leftMouseDraggedMonitor = {
        return EventMonitor(mask: NSEvent.EventTypeMask.leftMouseDragged) { [weak self] (event: NSEvent) in
            self?.handleLeftMouseDragged(event: event)
        }
    }()

    lazy var trayWindowController: TrayWindowController = {
        let controller = TrayWindowController(windowNibName: "TrayWindowController")
        return controller
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.button?.image = NSImage(named: "status-bar")
        leftMouseDraggedMonitor.start()
    }

    private func handleLeftMouseDragged(event: NSEvent) {
        let mouseLocation = NSEvent.mouseLocation
        let activeZone = trayRect()

        if activeZone.contains(mouseLocation) {
            showTray()
        } else {
            closeTray()
        }
    }

    private func showTray() {
        trayWindowController.window?.setFrame(trayRect(), display: true)
        trayWindowController.show()
    }

    private func closeTray() {
        trayWindowController.hide()
    }

    private func trayRect() -> CGRect {
        guard let statusItemButton = statusItem.button, let window = statusItemButton.window else {
            return CGRect.zero
        }
        let frameInWindow = statusItemButton.convert(statusItemButton.frame, to: nil)
        let frameOnScreen = window.convertToScreen(frameInWindow)
        let activeZoneSize = CGSize(width: 120, height: 44)

        let width = activeZoneSize.width
        let height = activeZoneSize.height

        let x = frameOnScreen.origin.x - (width - statusItemButton.frame.size.width) / 2
        let y = frameOnScreen.origin.y - height

        return CGRect(x: x, y: y, width: width, height: height)
    }
}
