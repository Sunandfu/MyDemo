//
//  AssetsCollection.swift
//  Alerts&Pickers
//
//  Created by Lex on 24.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation
import Photos

public final class AssetsCollection {
    
    // MARK: - Aliases
    public typealias Handler = (Event) -> ()
    
    
    // MARK: - Nested
    public enum Event {
        case failure(Error)
        case loaded
        case update([AssetsCollectionChange])
        case fullReloadNeeded
    }
    
    // MARK: - Vars
    
    /// Provides current assets
    public private(set) var assets: [PHAsset] = []
    
    /// Handler for assets updates
    public var handler: Handler? = nil
    
    /// Describes whether collection loading and observing were started or not.
    public private(set) var started: Bool = false
    
    private let observer = ChangesObserver.init()
    
    // MARK: - Funcs Public
    
    /// Starts loading and observing. If already started – does nothing.
    public func start() {
        
        guard !started else {
            return
        }
        
        reload()
    }
    
    // MARK: - Funcs Private
    
    private func reload() {
        
        Assets.fetchOriginal { [weak self] (result) in
            switch result {
            case .error(error: let error): self?.reportError(error)
            case .success(result: let fetchResult): self?.handle(fetchResult: fetchResult)
            }
        }
    }
    
    private func handle(fetchResult: PHFetchResult<PHAsset>) {
        setupAssets(fetchResult.dlg_assets)
        
        self.observer.handler = { [weak self] update in
            self?.handleUpdate(update)
        }
        self.observer.startObserving(fetchResult: fetchResult)
    }
    
    private func setupAssets(_ assets: [PHAsset]) {
        self.assets = assets
        self.handler?(.loaded)
    }
    
    private func reportError(_ error: Error) {
        self.handler?(.failure(error))
    }
    
    // MARK: - Funcs Private: Updates
    
    private func handleUpdate(_ update: ChangesObserver.Update) {
        switch update {
        case .nonicrementalUpdate:
            reload()
        case .changes(let changes):
            apply(changes: changes)
        }
    }
    
    private func apply(changes: [ChangesObserver.Change]) {
        var updatesAssets = assets
        changes.forEach({apply(change: $0, to: &updatesAssets)})
        
        assets = updatesAssets
        handler?(.update(changes))
    }
    
    private func apply(change: ChangesObserver.Change, to assets: inout [PHAsset]) {
        switch change {
        case .inserted(let asset, at: let idx): assets.insert(asset, at: idx)
        case .removed(_, at: let idx): assets.remove(at: idx)
        }
    }
    
}
