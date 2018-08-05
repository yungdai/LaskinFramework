//
//  DictionaryExtensions.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-12-21.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

extension Dictionary {
    init(keys: [Key], repeatedValue value: Value) {
        var dictionary: [Key: Value] = [:]
        keys.forEach { dictionary[$0] = value }
        self = dictionary
    }
    
    
    func getAllValuesFromDictionary() -> Array<Any> {
        
        return self.values.compactMap { $0 }
    }
    
    func countAllObjects() -> Int {
        
        return getAllValuesFromDictionary().count
    }
}
