//
//  CLPlacemark+Extensions.swift
//  Alerts&Pickers
//
//  Created by Lex on 04.10.2018.
//  Copyright © 2018 Supreme Apps. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

internal  extension CLPlacemark {
    
    var postalAddressIfAvailable: CNPostalAddress? {
        if #available(iOS 11.0, *) {
            return self.postalAddress
        }
        
        return nil
    }
    
}
