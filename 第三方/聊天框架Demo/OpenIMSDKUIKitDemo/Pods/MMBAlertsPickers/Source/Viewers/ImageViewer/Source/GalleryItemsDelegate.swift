//
//  GalleryDelegate.swift
//  ImageViewer
//
// Created by David Whetstone on 1/5/17.
// Copyright (c) 2017 MailOnline. All rights reserved.
//

import Foundation

public protocol GalleryItemsDelegate: class {
    func isItemSelected(at index: Int) -> Bool
    func itemSelectionIndex(at index: Int) -> Int?
    func removeGalleryItem(at index: Int)
    func sendItem(_ galleryViewController: GalleryViewController, at index: Int)
}
