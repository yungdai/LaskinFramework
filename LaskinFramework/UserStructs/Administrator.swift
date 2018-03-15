//
//  Administrator.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-11-01.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation


public struct Administrator: User, UserInfo, Codable  {
    
    public var id: Int? = 999
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var mobilePhone: String?
    public var officePhone: String?
    public var userType: UserType = .administrator
    public var privileges: AppPrivileges = .admin
    public var school: String?
    
    public init() {}
}
