//
//  UserModel.swift
//  LaskinFramework
//
//  Created by Yung Dai on 2018-09-05.
//  Copyright © 2018 Yung Dai. All rights reserved.
//

import Foundation

/// User when you need a model of the instead of the user protocll for a User
public struct UserModel: Codable {
	
	var userType: UserType
	var privileges: AppPrivileges
	var firstName: String?
	var lastName: String?
	var school: String?
	var fullName: String
	
	init(user: User) {
		
		self.userType = user.userType
		self.privileges = user.privileges
		self.firstName = user.firstName
		self.lastName = user.lastName
		self.school = user.school
		self.fullName = user.fullName
	}
}
