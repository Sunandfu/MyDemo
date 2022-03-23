//
//  TrayContainerView.swift
//  Portal
//
//  Created by wang ya on 2020/5/29.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

@objc protocol TrayContainerViewDragDelegate {
    func performDragOperation(draggingInfo: NSDraggingInfo) -> Bool
}

class TrayContainerView: NSView {

    @IBOutlet weak var delegate: TrayContainerViewDragDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerForDraggedTypes([NSPasteboard.PasteboardType.string, .URL])
    }

    private func shouldAllowDrag(draggingInfo: NSDraggingInfo) -> Bool {
        return draggingInfo.draggingPasteboard.canReadObject(forClasses: [NSURL.self, NSString.self], options: nil)
    }

    // MARK: NSDraggingDestination

    override func draggingEntered(_ draggingInfo: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(draggingInfo: draggingInfo)
        return allow ? NSDragOperation.copy : []
    }


    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        if let res = delegate?.performDragOperation(draggingInfo: draggingInfo) {
            return res
        }
        return false
    }
}
