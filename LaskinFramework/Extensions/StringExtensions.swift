//
//  StringExtensions.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-06-02.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import UIKit

extension String {
    
    public func base64Encode() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    static public func convertStringToDollarValue(_ string: String) -> String {
        
        // make sure you the value will have a dollar sign in front of it
        guard Double(string) != nil else { return "$0.00" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        
        return String(format: "$%.2f", string)
    }
    
    public static func getDayOfWeekAsString(_ dayAsInt: Int) -> String? {
        
        guard let weekDay = Day(rawValue: dayAsInt) else { return nil }

        switch weekDay {
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        }
    }
    
    static func getMonthAsString(_ monthAsInt: Int) -> String? {
        
        guard let month = Month(rawValue: monthAsInt) else { return nil }
        
        switch month {
        case .jan:
            return "January"
        case .feb:
            return "February"
        case .march:
            return "March"
        case .april:
            return "April"
        case .may:
            return "May"
        case .june:
            return "June"
        case .july:
            return "July"
        case .aug:
            return "August"
        case .sept:
            return "September"
        case .oct:
            return "October"
        case .nov:
            return "November"
        case .dec:
            return "December"
        }
    }
    
    static func deviceOrientation() -> String? {
        
        let device = UIDevice.current
        if device.isGeneratingDeviceOrientationNotifications {
            device.beginGeneratingDeviceOrientationNotifications()
            switch device.orientation {
            case .unknown:
                return "Unknown"
            case .portrait:
                return "Portrait"
            case .portraitUpsideDown:
                return "Upside Down"
            case .landscapeLeft:
                return "Landscape Left"
            case .landscapeRight:
                return "Landscape Right"
            case .faceUp:
                return "Camera Facing Up"
            case .faceDown:
                return "Camera Facing Down"
            }
        }
        return nil
    }
    
    static func getStringValueFromPlist(plistName: String, valueForKey: String) -> String! {
        
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: AnyObject] = [:]
        let plistPath: String? = Bundle.main.path(forResource: plistName, ofType: "plist")
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &plistFormat) as! [String: AnyObject]
        } catch {
            print("Error in plist")
        }
        
        return plistData[valueForKey]?.value as String!
    }
    
    func splitCamelCase() -> String {
        return unicodeScalars.flatMap { CharacterSet.uppercaseLetters.contains($0) ? " \($0)" : String($0) }.joined()
    }
    
    func initials() -> String {
        guard !self.isEmpty else { return "" }
        return components(separatedBy: " ").map({ String($0.first!) })
                .filter({ CharacterSet.letters.contains($0.unicodeScalars.first!) }).joined(separator: "")
    }

    subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
}
