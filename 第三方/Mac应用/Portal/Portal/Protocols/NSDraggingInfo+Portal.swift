//
//  NSDraggingInfo+Portal.swift
//  Portal
//
//  Created by wang ya on 2020/6/1.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

extension NSDraggingInfo {
    func getDraggingURL() -> URL? {
        if let string = draggingPasteboard.string(forType: NSPasteboard.PasteboardType.string) {
            return URL(string: string)
        } else if let string = draggingPasteboard.string(forType: NSPasteboard.PasteboardType.URL) {
            return URL(string: string)
        }
        return nil
    }
}
