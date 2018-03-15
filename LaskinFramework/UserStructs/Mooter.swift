//
//  Mooter.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-09-11.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation


public struct Mooter: User, UserInfo, School, AccessibilityRequirements, DietaryNeeds, MatchMaking, Codable  {

    public var id: Int? = 999
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var mobilePhone: String?
    public var officePhone: String?
    public var userType: UserType = .mooter
    public var privileges: AppPrivileges = .user
    
    public var schoolNumber: Int = 0
    public var shortName: String = ""
    public var school: String?
    public var city: String = ""
    public var province: Province?
    public var timeZone: LSATimeZone? {
        return province?.timeZone
    }
    
    public var requiresAccessibility: Bool = false
    public var accessibilityNeeds: String = ""
    
    public var needsInterpreter: Bool = false {
        didSet {
            if needsInterpreter {
                interpreterType = language == .english ? .french : .english
            } else {
                interpreterType = .none
            }
        }
    }
    
    public var hasDietaryNeeds: Bool = false
    public var dietaryNeeds: String = ""
    
    public var side: Side?
    public var language: Language = .english
    public var order: Order?
    private(set) public var interpreterType = Language.none
    
    public init() {}
}
