//
//  Researcher.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-09-11.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public struct Researcher: User, UserInfo, AccessibilityRequirements, DietaryNeeds, School, Codable {
 
    public var id: Int? = 999
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var mobilePhone: String?
    public var officePhone: String?
    public var userType: UserType = .researcher
    public var privileges: AppPrivileges = .user
    
    public var requiresAccessibility: Bool = false
    public var accessibilityNeeds: String = "N/A"
    
    public var hasDietaryNeeds: Bool = false
    public var dietaryNeeds: String = "N/A"

    public var schoolNumber: Int = 0
    public var shortName: String = ""
    public var school: String?
    public var city: String = ""
    public var province: Province?
    public var timeZone: LSATimeZone? {
        return province?.timeZone
    }
    
    public var willAttend: Bool = true
    
    public init() {}
}
