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
    
    public class func getUsersFromDefaults() -> Users? {
        
        if let unarchivedUserData = defaults.object(forKey: "Users") as? Data {
            
            return (NSKeyedUnarchiver.unarchiveObject(with: unarchivedUserData) as? Users)
        }
        
        return nil
    }

    public class func saveUsersToDefaults(users: Users?) {
        
        guard let userArray = users as Users? else  { return print("error in trying to save object") }
        
        let archivedUserData = NSKeyedArchiver.archivedData(withRootObject: userArray)
        defaults.set(archivedUserData, forKey: "Users")
        
    }
}
