//
// ChatLayout
// ChatLayoutInvalidationContext.swift
// https://github.com/ekazaev/ChatLayout
//
// Created by Eugene Kazaev in 2020-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Custom implementation of `UICollectionViewLayoutInvalidationContext`
public final class ChatLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {

    /// Indicates whether to recompute the positions and sizes of the items based on the current
    /// collection view and delegate layout metrics.
    public var invalidateLayoutMetrics = true

}
