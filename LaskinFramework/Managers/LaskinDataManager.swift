//
//  LaskinDataManager.swift
//  LaskinFramework
//
//  Created by Yung Dai on 2018-08-05.
//  Copyright © 2018 Yung Dai. All rights reserved.
//

import Foundation

public struct LaskinDataManager {
	
	var users: Users?
	var schedule: Schedule?
	var userManager: UserManager = UserManager()
	
	mutating func getUsers() -> Users? {

		userManager.getJSON {
			self.users = UserStore.sharedUserStore.userStore
		}
		
		return users
	}
}
