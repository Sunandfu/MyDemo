//
//  Bundle+Extensions.swift
//  Alerts&Pickers
//
//  Created by Lex on 13.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation

internal extension Bundle {
    
    internal var dlgpicker_appName: String {
        if let bundleName = self.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String {
            return bundleName
        }
        return ""
    }
    
}
