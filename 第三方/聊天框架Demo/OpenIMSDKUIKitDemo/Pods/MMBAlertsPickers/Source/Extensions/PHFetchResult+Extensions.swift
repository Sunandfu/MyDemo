//
//  PHFetchResult+Extensions.swift
//  Alerts&Pickers
//
//  Created by Lex on 24.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation
import Photos

internal extension PHFetchResult where ObjectType == PHAsset {
    
    var dlg_assets: [PHAsset] {
        var assets: [PHAsset] = []
        enumerateObjects { (item, _, _) in
            assets.append(item)
        }
        return assets
    }
}
