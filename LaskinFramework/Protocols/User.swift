//
//  User.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-06-18.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public protocol User: Codable, Nameable {
    
    var userType: UserType { get set }
    var privileges: AppPrivileges { get set }
    var firstName: String? { get }
    var lastName: String? { get }
    var school: String? { get }
    var fullName: String { get }
}

public extension User {
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
}

public protocol UserInfo: Codable {
    
    var id: Int? { get }
    var emailAddress: String? { get }
    var mobilePhone: String? { get set }
    var officePhone: String? { get set }
}

public protocol School: Codable {
    
    var schoolNumber: Int { get set }
    var school: String? { get }
    var shortName: String { get set }
    var city: String { get set }
    var province: Province? { get set }
    var timeZone: LSATimeZone? { get }
}

public protocol ConflictingSchools: Codable {
    
    var conflictingSchools: [School] { get set }
}

public protocol AccessibilityRequirements: Codable {
    
    var requiresAccessibility: Bool { get set }
    var accessibilityNeeds: String { get set }
}

public protocol DietaryNeeds: Codable {
    
    var hasDietaryNeeds: Bool { get set }
    var dietaryNeeds: String { get set }
}

public protocol MatchMaking: Codable {
    
    var needsInterpreter: Bool { get set }
    var order: Order? { get set }
    var interpreterType: Language { get }
}

