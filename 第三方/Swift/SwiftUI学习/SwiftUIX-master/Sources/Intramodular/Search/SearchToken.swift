//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

public struct SearchToken: Codable, Hashable {
    public let text: String
}

// MARK: - Auxiliary Implementation -

#if os(iOS) || targetEnvironment(macCatalyst)
extension UISearchToken {
    var _SwiftUIX_text: String {
        representedObject as! String
    }
    
    public convenience init(_ token: SearchToken) {
        self.init(icon: nil, text: token.text)
        
        self.representedObject = token.text
    }
}
#endif
