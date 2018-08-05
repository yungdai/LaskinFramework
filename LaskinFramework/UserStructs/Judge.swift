//
//  Judge.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2016-09-11.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation

public struct Judge: User, UserInfo, School, MatchMaking, Codable {

    public var id: Int? = 999
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var mobilePhone: String?
    public var officePhone: String?
    public var userType: UserType = .judge
    public var privileges: AppPrivileges = .user
    public var schoolNumber: Int = 0
    public var shortName: String = ""
    public var school: String?
    public var city: String = " "
    public var province: Province?
    public var timeZone: LSATimeZone? {
        return province?.timeZone
    }
    
    public var gender: Gender = .notApplicable
    public var englishOnly: Bool = false {
        didSet {
            frenchSpeaking = !englishOnly
        }
    }
    public var isRealJudge: Bool = false
    public var hardConflicts: String?
    public var softConflicts: String?
    public var judgeExperience: JudgeExperience = .notAJudge
    
    // for Colin's API to be refactor later
    public var frenchSpeaking: Bool = false
    
    // matchmaking protocol
    public var needsInterpreter: Bool = false {
        didSet {
            if needsInterpreter {
                interpreterType = englishOnly ? .french : .english
            } else {
                interpreterType = .none
            }
        }
    }

    public var order: Order?
    public private(set) var interpreterType = Language.none
    
    
    public init() {}
}
