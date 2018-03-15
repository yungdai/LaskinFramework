//
//  MatchLogicStructs.swift
//  LaskinMobileApp
//
//  Created by Yung Dai on 2017-10-16.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

public struct LMSchool: Codable {
    
    public var name: String
    public var city: String
    public var province: Province
    public var timeZone: LSATimeZone {
        return province.timeZone
    }
}

extension LMSchool: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
    
    public static func == (lhs: LMSchool, rhs: LMSchool) -> Bool {
        return lhs.name == rhs.name && lhs.city == rhs.city && lhs.province == rhs.province
    }
}

public struct LMMooter: Codable {
    public var firstName: String
    public var lastName: String
    public var school: LMSchool
    public var side: Side
    public var order: Order
    public var language: Language
    public var interpreterType: Language
    
    public var position: String {
        return "\(side.initial)\(order.rawValue)"
    }

}

extension LMMooter: Equatable {
    public init?(mooter: Mooter) {
        guard let firstName = mooter.firstName, let lastName = mooter.lastName, let schoolName = mooter.school,
            let province = mooter.province, let side = mooter.side, let order = mooter.order else { return nil }
        self.init(firstName: firstName, lastName: lastName, school: LMSchool(name: schoolName, city: mooter.city, province: province),
                  side: side, order: order, language: mooter.language, interpreterType: mooter.interpreterType)
    }
    
    
    
    public static func == (lhs: LMMooter, rhs: LMMooter) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.school == rhs.school &&
            lhs.side == rhs.side && lhs.order == rhs.order && lhs.language == rhs.language && lhs.interpreterType == rhs.interpreterType
    }
}

public struct Pair: Codable {
    public var firstMooter: LMMooter
    public var secondMooter: LMMooter
    public var hoursAhead = 99
    public var matchCount = 99
    
    public var side: Side {
        return firstMooter.side
    }
    
    public var school: LMSchool {
        return secondMooter.school
    }
    
    public init?(firstMooter: LMMooter, secondMooter: LMMooter, hoursAhead: Int, matchCount: Int) {
        guard firstMooter.side == secondMooter.side &&
            firstMooter.order != secondMooter.order else { return nil }
        self.firstMooter = firstMooter
        self.secondMooter = secondMooter
        self.hoursAhead = hoursAhead
        self.matchCount = matchCount
    }
    
    /// Returns the types of interpreters needed. If no interpreter is needed the array will be empty.
    public func interpreterTypesNeeded() -> [Language] {
        return Set([firstMooter.interpreterType, secondMooter.interpreterType]).filter { $0.isValidLanguage }
    }
}

extension Pair: Equatable {
    public static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.firstMooter == rhs.firstMooter && lhs.secondMooter == rhs.secondMooter
            && lhs.hoursAhead == rhs.hoursAhead && lhs.matchCount == rhs.matchCount
    }
}

public struct Match: Codable {
    public var appellantPair: Pair
    public var respondentPair: Pair
    public var hoursAhead = 99
    public var roomNumber = 99     // 0-based
    public var sessionNumber = 99     // 0-based
    public var needsInterpreter = false
    public var demerits = 0
}

extension Match: Equatable {
    public static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.appellantPair == rhs.appellantPair && lhs.respondentPair == rhs.respondentPair
            && lhs.hoursAhead == rhs.hoursAhead && lhs.roomNumber == rhs.roomNumber
            && lhs.sessionNumber == rhs.sessionNumber && lhs.needsInterpreter == rhs.needsInterpreter
            && lhs.demerits == rhs.demerits
    }
}
