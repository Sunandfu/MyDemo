//
//  TelegramPickerGalleryItemsDataSource.swift
//  Alerts&Pickers
//
//  Created by Lex on 23.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import UIKit

internal extension TelegramPickerViewController {
    
    internal class TelegramPickerGalleryItemsDataSource: GalleryItemsDataSource {
        
        weak var controller: TelegramPickerViewController?
        
        init(controller: TelegramPickerViewController) {
            self.controller = controller
        }
        
        func itemCount() -> Int {
            return self.controller?.galleryItems.count ?? 0
        }
        
        func provideGalleryItem(_ index: Int) -> GalleryItem {
            
            if let controller = controller {
                return controller.galleryItems[index].galleryItem ?? GalleryItem.image(fetchImageBlock: { $0(UIImage()) })

            }
            return GalleryItem.image(fetchImageBlock: { $0(UIImage()) })
        }
        
    }
    
    internal func createGalleryItemsDataSource() -> GalleryItemsDataSource {
        return TelegramPickerGalleryItemsDataSource.init(controller: self)
    }
    
}
