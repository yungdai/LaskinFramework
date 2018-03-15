//
//  UserStore.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-11-15.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public class UserStore: NSObject {
    
    public static let sharedUserStore: UserStore = {
        return UserStore.emptyUserStore()
    }()
    
    public var userStore: [UserType: [User]]
    
    public init(store: [UserType: [User]]) {
        userStore = store
    }
    
    // MARK: - Empty out the usersStore
    public class func emptyUserStore() -> UserStore {
        return UserStore(store:  [UserType: [User]]())
    }
    
    // MARK: - Convenience functions manipulating the userStore
    public func users(for userType: UserType) -> [User]? {
        return userStore[userType]
    }
    
    public func user(at index: Int, for userType: UserType) -> User? {
        return users(for: userType)?[index]
    }
    
    public class func getUserCount() -> Int {
        return UserStore.sharedUserStore.userStore.reduce(0) { $0 + $1.value.count }
    }
    
    public class func getAllUsers() -> [User]? {
        return  UserStore.sharedUserStore.userStore.values.flatMap { $0 }
    }
    
    public func sortUsers(for userType: UserType, by sortType: SortType ) {
        
        userStore[userType] = users(for: userType)?.sorted {
            
            switch sortType {
                
            case .firstName:
                return $0.firstName! < $1.firstName!
                
            case .lastName:
                return  $0.lastName! < $1.lastName!
                
            case .school:
                return   $0.school! < $1.school!
                
            case .userType:
                return $0.userType.rawValue < $1.userType.rawValue
            }
        }
    }
    
    // use this to insert a group of users into the userStore
    public func insert(users: [User], into userType: UserType, at index: Int) {
        
        var usersToInsert: [User] = [User]()
        users.forEach { var user: User = $0
            
            user.userType = userType
            
            usersToInsert.append(user)
        }
        
        if userStore[userType] == nil {
            
            userStore[userType] = usersToInsert
        } else {
            
            userStore[userType]?.insert(contentsOf: usersToInsert, at: index)
        }
    }
    
    public func deleteUsers(at indexes: [Int], for userType: UserType) -> [User] {

        // TODO: rewrite for multiselection in the future
        let pluckedUsers = users(for: userType)?
            .enumerated()
            .filter { indexes.contains($0.offset ) }
            .map { $0.element }
        
        userStore[userType] = users(for: userType)?
            .enumerated()
            .filter { indexes.contains($0.offset) }
            .map { $0.element }
        
        return pluckedUsers!
    }
}
