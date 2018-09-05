//
//  ContactPerson.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-09-11.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public struct ContactPerson: User, UserInfo, Codable {
    
    public var id: Int? = 999
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var mobilePhone: String?
    public var officePhone: String?
    public var userType: UserType = .administrator
    public var privileges: AppPrivileges = .none
    public var isEnglishOK: Bool = true
    public var school: String?
    
    public init() {}
}
