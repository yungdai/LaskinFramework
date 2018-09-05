//
//  Utilities.swift
//  EMobileView
//
//  Created by Yung Dai on 2016-12-12.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import UIKit

public class Utilities: NSObject {
    
    static let defaults = UserDefaults.standard

    public func delay(seconds: Double, completion: @escaping ()-> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
	
	// TODO: Untested Will need to write a test for this
    public class func getUsersFromDefaults() -> Users? {

        if let unarchivedUserData = defaults.object(forKey: "Users") as? Data {

			do {
				guard let defaultData: DefaultData = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [DefaultData.self], from: unarchivedUserData) as? DefaultData else { return nil }
				return defaultData.users
			} catch {
				print(error)
			}
        }
        
        return nil
    }

    public class func saveUsersToDefaults(users: Users?) {
        
        guard let users = users as Users? else  { return print("error in trying to save object") }
		let defaultUserData = DefaultData(users: users)

		do {
			let archivedUserData = try NSKeyedArchiver.archivedData(withRootObject: defaultUserData, requiringSecureCoding: false)
			defaults.set(archivedUserData, forKey: "Users")
		} catch {
			print(error)
		}

    }
}
