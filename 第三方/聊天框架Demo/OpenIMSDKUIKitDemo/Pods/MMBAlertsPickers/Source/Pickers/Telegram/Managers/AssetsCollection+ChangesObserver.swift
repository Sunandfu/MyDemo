//
//  AssetsCollection+ChangesObserver.swift
//  Alerts&Pickers
//
//  Created by Lex on 24.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation
import Photos

public enum AssetsCollectionChange {
    
    case inserted(PHAsset, at: Int)
    case removed(PHAsset, at: Int)
    
    public func shifted(offset: Int) -> AssetsCollectionChange {
        switch self {
        case .inserted(let asset, at: let idx): return .inserted(asset, at: idx + offset)
        case .removed(let asset, at: let idx): return .removed(asset, at: idx + offset)
        }
    }
    
    public static func shift(changes: [AssetsCollectionChange], offset: Int) -> [AssetsCollectionChange] {
        let shiftedChanges = changes.map({$0.shifted(offset: offset)})
        return shiftedChanges
    }
    
}

internal extension AssetsCollection {
    
    // MARK: - Changes Observer
    
    internal class ChangesObserver: NSObject, PHPhotoLibraryChangeObserver {
        
        // MARK: - Nested
        
        typealias Change = AssetsCollectionChange
        
        public enum Update {
            case changes([Change])
            case nonicrementalUpdate
        }
        
        // MARK: - Vars
        
        private var lastFetchResult: PHFetchResult<PHAsset>? = nil
        
        public var handler: ((Update)->())? = nil
        
        public private(set) var observing = false
        
        // MARK: - Funcs
        
        deinit {
            stopObserving()
        }
        
        public func startObserving(fetchResult: PHFetchResult<PHAsset>) {
            
            guard !observing else {
                return
            }
            
            lastFetchResult = fetchResult
            PHPhotoLibrary.shared().register(self)
        }
        
        public func stopObserving() {
            guard observing else {
                return
            }
            
            PHPhotoLibrary.shared().unregisterChangeObserver(self)
        }
        
        internal func photoLibraryDidChange(_ changeInstance: PHChange) {
            DispatchQueue.main.async {
                self.handleLibraryChange(changeInstance)
            }
        }
        
        private func handleLibraryChange(_ changeInstance: PHChange) {
            if let fetchResult = lastFetchResult, let details = changeInstance.changeDetails(for: fetchResult) {
                reportChanges(details: details)
            }
        }
        
        private func reportChanges(details: PHFetchResultChangeDetails<PHAsset>) {
            
            guard details.hasIncrementalChanges else {
                handler?(.nonicrementalUpdate)
                return
            }
            
            guard details.insertedObjects.isEmpty == false || details.removedObjects.isEmpty == false else {
                return
            }
            
            self.lastFetchResult = details.fetchResultAfterChanges
            
            var changes = removedAssetsChanges(details: details)
            changes.append(insertedAssetsChanges(details: details))
            
            handler?(.changes(changes))
        }
        
        private func mapToChanges(indexes: IndexSet?, assets: [PHAsset], mapper: (Int, PHAsset) -> Change) -> [Change] {
            
            guard let indexes = indexes else {
                return []
            }
            
            let changes = indexes.enumerated().reversed().map { (assetIdx, assetPosition) -> Change in
                let asset = assets[assetIdx]
                let change = mapper(assetPosition, asset)
                return change
            }
            return changes
        }
        
        private func insertedAssetsChanges(details: PHFetchResultChangeDetails<PHAsset>) -> [Change] {
            let idxs = details.insertedIndexes
            let assets = details.insertedObjects
            let changes = mapToChanges(indexes: idxs, assets: assets) { (assetPosition, asset) -> Change in
                return Change.inserted(asset, at: assetPosition)
            }
            return changes
        }
        
        private func removedAssetsChanges(details: PHFetchResultChangeDetails<PHAsset>) -> [Change] {
            let idx = details.removedIndexes
            let assets = details.removedObjects
            let changes = mapToChanges(indexes: idx, assets: assets) { (assetPosition, asset) -> Change in
                return Change.removed(asset, at: assetPosition)
            }
            return changes
        }
        
    }
    
}
