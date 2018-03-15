//
//  Functions.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-11-04.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public func unwrap(any: Any) -> Any? {
    
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle != .optional {
        return any
    }
    
    if mirror.children.count == 0 { return nil }
    return mirror.children.first!.value
}
