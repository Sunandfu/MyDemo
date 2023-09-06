//
//  TelegramPickerConfigurator.swift
//  Alerts&Pickers
//
//  Created by Lex on 30.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation


public protocol TelegramPickerConfigurator {
    
    func modifyGalleryConfig(_ config: inout GalleryConfiguration)
    
}

open class SimpleTelegramPickerConfigurator: TelegramPickerConfigurator {
    
    public func modifyGalleryConfig(_ config: inout GalleryConfiguration) {
        // do nothing
    }
    
    public init() {
        // do nothing
    }
    
}
