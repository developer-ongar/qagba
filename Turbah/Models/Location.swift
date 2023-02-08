//
//  Location.swift
//  Turbah
//
//  Created by MMQ on 7/17/20.
//  Copyright © 2020 MMQ. All rights reserved.
//

import Foundation

enum Locations: CaseIterable {
    case kabah

    
    var coordinates: Coordinates {
        switch self {
        //Adhan's coordinates for Kabah: Coordinates(lat: 21.4225241, lon: 39.8261818)
        case .kabah:     return Coordinates(lat: 21.422487, lon: 39.826206)
        }
    }
    
    var name: String {
        switch self {
        case .kabah:     return "Kaba".localized
        
        }
    }
    
    var compassIconString: String {
        return self == .kabah ? "kaba" : "shrine"
    }
    
//    var imageString: String {
//        switch self {
//        case .kabah:     return ""
//        }
//    }
    
}
