//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension GeometryProxy {
    public var insetAdjustedSize: CGSize {
        .init(
            width: size.width - (safeAreaInsets.leading + safeAreaInsets.trailing),
            height: size.height - (safeAreaInsets.top + safeAreaInsets.bottom)
        )
    }
}
