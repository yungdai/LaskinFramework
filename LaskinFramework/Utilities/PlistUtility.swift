//
//  PlistUtility.swift
//  EMobileView
//
//  Created by Yung Dai on 2017-02-07.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public class PlistUtility: NSObject {

    public func getValueFromPlist(forResource fileName: String, fileExtension: String, key: String) -> AnyObject? {
        
        guard let plistPath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else { return nil }
        
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return nil }
        
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        guard let plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainers, format: &format) as? [String: AnyObject] else { return nil }
        
        if let value = plistDict[key] as AnyObject? {
            
            return value
        }
        
        return nil
    
    }
}
