//
//  EventMonitor.swift
//  Portal
//
//  Created by wang ya on 2020/5/28.
//  Copyright © 2020 EYA-Studio. All rights reserved.
//

import Cocoa

class EventMonitor: NSObject {
    private var mask: NSEvent.EventTypeMask!
    private var handler: ((_ event: NSEvent)->Void)!
    private var monitor: Any?

    init(mask: NSEvent.EventTypeMask, handler: @escaping (_ event: NSEvent)->Void) {
        super.init()
        self.mask = mask
        self.handler = handler
    }

    public func start() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: self.mask) { [weak self] (event: NSEvent) in
            self?.handler(event)
        }
    }

    public func stop() {
        if let monitor = self.monitor {
            NSEvent.removeMonitor(monitor)
        }
        self.monitor = nil
    }
}
